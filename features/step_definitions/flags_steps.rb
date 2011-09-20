Given /^the following flags:$/ do |flags|
  Flags.create!(flags.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) flags$/ do |pos|
  visit flags_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following flags:$/ do |expected_flags_table|
  expected_flags_table.diff!(tableish('table tr', 'td,th'))
end
