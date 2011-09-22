Given /^I move into the examples directory$/ do
  When "I run \"cd #{examples_path}\""
end

When /^I run "([^"]*)"$/ do |arg1|
  fill_in("input", :with => arg1)
  find_field('input').native.send_key(:enter)
end

Then /^I should get (.+) path$/ do |arg1|
  page.all('.command').last.should have_content(path_to(arg1))
end

Then /^I should get (.+) path with "([^"]*)" appended$/ do |arg1, arg2|
  page.all('.command').last.should have_content(File.join(path_to(arg1), arg2))
end

Given /^I start my server with environment:$/ do |table|
  table.hashes.each do |hash|
    Given "I run \"set #{hash['variable']}=#{hash['value']}\""
  end
end


