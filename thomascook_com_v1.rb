#!/usr/bin/env ruby

require 'selenium-webdriver'
require 'headless'
require 'fileutils'

headless = Headless.new
headless.start
client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 300
driver = Selenium::WebDriver.for(:firefox, :http_client => client) 
retval = 0
screenfile = "#{Time.now.strftime("%d.%m.%Y__%H'%M'%S")}.png"
retry_count = 5

FileUtils.mkdir_p 'thomascook.com_v1'
FileUtils.rm_rf(Dir.glob('thomascook.com_v1/*'))

driver.manage.window.maximize
driver.manage.timeouts.page_load = 120
driver.manage.timeouts.implicit_wait = 120 

def teardown(headless,driver,screenfile,retval)
  driver.save_screenshot("thomascook.com_v1/#{screenfile}")
  driver.quit
  headless.destroy
  exit retval  
end



# Access thomascook.com
begin
  driver.navigate.to "http://www.thomascook.com"
rescue => exception
  retry_count -= 1
  if retry_count > 0
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died loading http://www.thomascook.com"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Click search button
begin
  url = driver.current_url
  driver.find_element(:xpath, "//button[@class='btn btn-primary searchPanel-commandBtn searchPanel-searchBtn js-btn-search']").click
rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Click the first details button
begin
  url = driver.current_url
  driver.find_element(:xpath, "//a[@class='btn btn-primary btn-heavy btn-block cta-arrow-right src-srpResult-ctaButton']").click
rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

#Click Book now
begin
  url = driver.current_url
  driver.find_element(:xpath, "//a[@class='priceTicket-bookButton btn btn-primary cta-arrow-right btn-heavy']").click
rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Continue to signing forms
begin
  url = driver.current_url
  driver.find_element(:xpath, "//a[@class='btn btn-primary cta-arrow-right pull-right']").location_once_scrolled_into_view
  driver.find_element(:xpath, "//a[@class='btn btn-primary cta-arrow-right pull-right']").click
rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Insert postcode and look for the location to appear
begin
  url = driver.current_url
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "title_lead")).select_by :text, "Mr"
  driver.find_element(:id, "firstName_lead").send_keys "Luke"
  driver.find_element(:id, "lastName_lead").send_keys "Skywalker"
  driver.find_element(:id, "email").send_keys "jediknight@gmail.com"
  driver.find_element(:id, "confirmEmail").send_keys "jediknight@gmail.com"
  Postcode = driver.find_element(:name, "addressFormBean.postCode")
  Postcode.location_once_scrolled_into_view
  Postcode.send_keys "GU249DQ"
  main_window = driver.window_handle
  driver.find_element(:xpath, "//a[@class='btn btn-default']").click
  sleep 5
  driver.switch_to.window(main_window)

  Streetname = driver.find_element(:name, "addressFormBean.streetAddress")
  Streetname.location_once_scrolled_into_view
  unless Streetname.attribute('value').include? "PILGRIMS WAY"
    fail "Street box does not contain PILGRIMS WAY"
  end

  City = driver.find_element(:name, "addressFormBean.city")
  City.location_once_scrolled_into_view
  unless City.attribute('value').include? "WOKING"
    fail "City box does not contain WOKING"
  end

  CountryDropdown = driver.find_element(:name, "addressFormBean.country")
  CountryDropdown.location_once_scrolled_into_view
  Option = CountryDropdown.find_element(tag_name: "option")
  unless Option.attribute('value').include? "UK"
    fail "Country box does not contain United Kingdom"
  end

  driver.find_element(:id, "houseNumber").send_keys "1"

  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "day_lead")).select_by :text, "13"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "month_lead")).select_by :text, "June"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "year_lead")).select_by :text, "1990"
  driver.find_element(:id, "contactNumber").send_keys "02072194272"

  driver.find_element(:xpath, "//label[@class='col-md-4 col-sm-12 col-xs-12 control-label']").click
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "title_1")).select_by :text, "Mrs"
  driver.find_element(:id, "firstName_1").send_keys "Mara"
  driver.find_element(:id, "lastName_1").send_keys "Skywalker"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "day_1")).select_by :text, "25"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "month_1")).select_by :text, "April"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "year_1")).select_by :text, "1992"

  driver.find_element(:id, "continuePaxButton").click


rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

puts "thomascook.com v1 is well!"

teardown(headless,driver,screenfile,retval)
