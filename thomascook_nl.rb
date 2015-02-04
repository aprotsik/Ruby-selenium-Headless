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

FileUtils.mkdir_p 'thomascook.nl'
FileUtils.rm_rf(Dir.glob('thomascook.nl/*'))

driver.manage.window.maximize
driver.manage.timeouts.page_load = 60
driver.manage.timeouts.implicit_wait = 60 

def teardown(headless,driver,screenfile,retval)
  driver.save_screenshot("thomascook.nl/#{screenfile}")
  driver.quit
  headless.destroy
  exit retval  
end



# Access thomascook.nl
begin
  driver.navigate.to "http://thomascook.nl"
rescue => exception
  retry_count -= 1
  if retry_count > 0
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died loading http://thomascook.nl"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Click search button
begin
  url = driver.current_url
  driver.find_element(:id, "st_popup_acceptButton").click
  driver.find_element(:xpath, "//a[@class='btn']").click
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
  driver.find_element(:xpath, "//a[@class='btn']").click
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
  driver.find_element(:id, "costAnchor").click
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
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "title_0")).select_by :text, "de heer"
  driver.find_element(:id, "firstName_0").send_keys "Luke"
  driver.find_element(:id, "lastName_0").send_keys "Skywalker"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm0.dayOB")).select_by :text, "13"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm0.monthOB")).select_by :text, "Juni"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm0.yearOB")).select_by :text, "1990"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "title_1")).select_by :text, "Mevrouw"
  driver.find_element(:id, "firstName_1").send_keys "Mara"
  driver.find_element(:id, "lastName_1").send_keys "Skywalker"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm1.dayOB")).select_by :text, "25"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm1.monthOB")).select_by :text, "Apr"
  Selenium::WebDriver::Support::Select.new(driver.find_element(:id => "passengerFormBean.passengerListForm1.yearOB")).select_by :text, "1992"
  driver.find_element(:id, "streetAddress").send_keys "Rokin"
  driver.find_element(:id, "houseNumber").send_keys "1"
  driver.find_element(:id, "postcode").send_keys "NL-1000"
  driver.find_element(:id, "townCity").send_keys "Amsterdam"
  driver.find_element(:id, "contactNumber").send_keys "+31 30 2357822"
  driver.find_element(:id, "email").send_keys "luke.skywalker@gmail.com"
  driver.find_element(:id, "confirmEmail").send_keys "luke.skywalker@gmail.com"
  driver.find_element(:id, "emergencyName").send_keys "Obiwan"
  driver.find_element(:id, "emergencyTelephone").send_keys "+31 30 2357822"
  driver.find_element(:xpath, "//input[@class='btn']").click

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

puts "thomascook.nl is well!"

teardown(headless,driver,screenfile,retval)
