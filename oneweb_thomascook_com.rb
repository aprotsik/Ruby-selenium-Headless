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

FileUtils.mkdir_p 'oneweb.thomascook.com'
FileUtils.rm_rf(Dir.glob('oneweb.thomascook.com/*'))

driver.manage.window.maximize
driver.manage.timeouts.page_load = 60
driver.manage.timeouts.implicit_wait = 60 

def teardown(headless,driver,screenfile,retval)
  driver.save_screenshot("oneweb.thomascook.com/#{screenfile}")
  driver.quit
  headless.destroy
  exit retval  
end



# Access oneweb.thomascook.com
 begin
  driver.navigate.to "http://oneweb.thomascook.com"
 rescue => exception
  retry_count -= 1
  if retry_count > 0
    retry
  else
    retval = 5
    puts exception.backtrace
    puts "Died loading http://oneweb.thomascook.com"
    teardown(headless,driver,screenfile,retval)
  end
ensure
  retry_count = 5
end

# Login as guest
begin
  url = driver.current_url
  driver.find_element(:id, "testLogin").click
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

# Click Search
begin
  url = driver.current_url
  driver.find_element(:id, "pkgProductSearch").click
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

#Select resort
begin
  url = driver.current_url
  driver.find_element(:xpath, "//a[@class='fontIcon-arrow-right']").click
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

# Click checkout
begin
  url = driver.current_url
  driver.find_element(:xpath, "//a[@class='book']").click
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

# Accept terms & Click continue booking
begin
  url = driver.current_url
  driver.find_element(:id, "errataTerms").click
  driver.find_element(:id, "acceptErata").click
  driver.find_element(:id, "continueButton").click
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

puts "oneweb.thomascook.com is well!"

teardown(headless,driver,screenfile,retval)
