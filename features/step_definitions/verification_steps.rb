Then /^I should see my Action List$/ do
  kaikifs.pause(1)
  kaikifs.wait_for(:xpath, "//div[@id='headerarea-small']")
  kaikifs.is_text_present("Action List").should == true
end

Then /^I should see "([^"]*)"$/ do |text|
  kaikifs.pause(1)
  kaikifs.is_text_present(text).should == true
end

# WD
Then /^I should see the message "([^"]*)"$/ do |text|
  kaikifs.pause(1)
  kaikifs.wait_for(:xpath, "//div[@class='msg-excol']")
  kaikifs.is_text_present(text, "//div[@class='msg-excol']/div/div").should == true
end

# WD
Then /^I should see "([^"]*)" in the "([^"]*)" iframe$/ do |text, frame|
  kaikifs.select_frame(frame+"IFrame")
  wait = Selenium::WebDriver::Wait.new(:timeout => 8)
  wait.until { kaikifs.find_element(:xpath, "//div[@id='workarea']") }
  kaikifs.is_text_present(text).should == true
  kaikifs.switch_to.default_content
  kaikifs.pause(1)
  kaikifs.select_frame("iframeportlet")
end

# WD
Then /^I should see "([^"]*)" in the route log$/ do |text|
  refresh_tries = 5
  wait_time = 1

  kaikifs.select_frame("routeLogIFrame")
  begin
    wait = Selenium::WebDriver::Wait.new(:timeout => 4).
      until { kaikifs.find_element(:xpath, "//div[@id='workarea']") }
    if kaikifs.is_text_present(text)
      kaikifs.is_text_present(text).should == true
    end
  rescue Selenium::WebDriver::Error::TimeOutError => command_error
    puts "#{refresh_tries} retries left... #{Time.now}"
    refresh_tries -= 1
    if refresh_tries == 0
      kaikifs.is_text_present(text).should == true
    end
    kaikifs.pause wait_time

    kaikifs.click_and_wait :alt, "refresh"  # 'refresh'
    retry
  ensure
    kaikifs.switch_to.default_content
    kaikifs.pause(1)
    kaikifs.select_frame("iframeportlet")
  end
end

Then /^I should see "([^"]*)" in "([^"]*)"$/ do |text, el|
  kaikifs.select_frame("iframeportlet")
  puts kaikifs.wait_for_text(text, :element => el, :timeout_in_seconds => 30);
  kaikifs.switch_to.default_content
  kaikifs.pause(1)
end

Then /^I shouldn't get an HTTP Status (\d+)$/ do |status_no|
  if status_no == '500'
    kaikifs.pause(1)
    kaikifs.is_text_present('HTTP Status 500').should_not == true
  end
end

# WD
Then /^I shouldn't see an incident report/ do
  kaikifs.is_text_present('Incident Report').should_not == true
end
