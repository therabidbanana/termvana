Then /^my working directory should be "([^"]*)"$/ do |arg1|
  page.should have_css("#current_working_dir", :text => arg1)
end

Then /^I should get "([^"]*)"$/ do |arg1|
  page.all('.code').last.should have_content(arg1)
end

Then /^I should get an error saying "([^"]*)"$/ do |arg1|
  page.all('.code.error').last.should have_content(arg1)
end


