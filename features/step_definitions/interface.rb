Then /^my working directory should be "([^"]*)"$/ do |arg1|
  page.should have_css("#current_working_dir", :text => arg1)
end

