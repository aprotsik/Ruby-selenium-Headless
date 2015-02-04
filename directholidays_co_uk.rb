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
screenfile = "#{Time.now.strftime("%d.%m.%Y__%H'%M'%S")}.jpg"
retry_count = 5

FileUtils.mkdir_p 'directholidays.co.uk'
FileUtils.rm_rf(Dir.glob('directholidays.co.uk/*'))

driver.manage.window.maximize
driver.manage.timeouts.page_load = 60
driver.manage.timeouts.implicit_wait = 60 

def teardown(headless,driver,screenfile,retval)
  driver.save_screenshot("directholidays.co.uk/#{screenfile}")
  driver.quit
  headless.destroy
  exit retval  
end



# Access directholidays.co.uk
begin
  driver.navigate.to "http://www.directholidays.co.uk"
rescue => exception
  retry_count -= 1
  if retry_count > 0
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died loading http://www.directholidays.co.uk"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Click search button
begin
  url = driver.current_url
  driver.find_element(:id, "bBookNow").click
rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    screenfile = "Fail_#{Time.now.strftime("%d.%m.%Y__%H'%M'%S")}.jpg"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Click the first details button
begin
  url = driver.current_url
  driver.find_element(:xpath, "//a[@onclick='showAccomodationWaitPage(event)']").click
rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    screenfile = "Fail_#{Time.now.strftime("%d.%m.%Y__%H'%M'%S")}.jpg"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

#Click Book now
begin
  url = driver.current_url
  driver.find_element(:id, "bookNowLink_1").click
rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    screenfile = "Fail_#{Time.now.strftime("%d.%m.%Y__%H'%M'%S")}.jpg"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Continue to signing forms
begin
  url = driver.current_url
  driver.find_element(:xpath, "//a[@class='btn nextBtn btn-sec']").click
rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    screenfile = "Fail_#{Time.now.strftime("%d.%m.%Y__%H'%M'%S")}.jpg"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Fill the passenger details
begin
  url = driver.current_url
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "title_0")).select_by :text, "Mr"
  driver.find_element(:id, "firstName_0").send_keys "Luke"
  driver.find_element(:id, "lastName_0").send_keys "Skywalker"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm0.dayOB")).select_by :text, "13"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm0.monthOB")).select_by :text, "June"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm0.yearOB")).select_by :text, "1990"

  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "title_1")).select_by :text, "Mrs"
  driver.find_element(:id, "firstName_1").send_keys "Mara"
  driver.find_element(:id, "lastName_1").send_keys "Skywalker"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm1.dayOB")).select_by :text, "25"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm1.monthOB")).select_by :text, "April"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm1.yearOB")).select_by :text, "1992"

  Postcode = driver.find_element(:id, "postcode")
  Postcode.location_once_scrolled_into_view
  Postcode.send_keys "GU249DQ"

  driver.find_element(:id, "findAddressButton").click
  sleep 5

  Street = driver.find_element(:id, "streetAddress")
  Street.location_once_scrolled_into_view
  unless Street.attribute('value').include? "PILGRIMS WAY"
    fail "Street box does not contain WOKING"
  end

  City = driver.find_element(:id, "townCity")
  City.location_once_scrolled_into_view
  unless City.attribute('value').include? "WOKING"
    fail "City box does not contain WOKING"
  end

  CountryDropdown = driver.find_element(:id, "countrySelect")
  CountryDropdown.location_once_scrolled_into_view
  Option = CountryDropdown.find_element(tag_name: "option")
  unless Option.attribute('value').include? "UK"
    fail "Country box does not contain United Kingdom"
  end

  driver.find_element(:id, "houseNumber").send_keys "1"
  driver.find_element(:id, "contactNumber").send_keys "02072194272"
  driver.find_element(:id, "email").send_keys "jediknight@gmail.com"
  driver.find_element(:id, "confirmEmail").send_keys "jediknight@gmail.com"
  driver.find_element(:xpath, "//input[@value='CONTINUE']").click


rescue => exception
  retry_count -= 1
  if retry_count > 0
    driver.navigate.refresh
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died on #{url}"
    screenfile = "Fail_#{Time.now.strftime("%d.%m.%Y__%H'%M'%S")}.jpg"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

puts "directholidays.co.uk is well!"

teardown(headless,driver,screenfile,retval)
