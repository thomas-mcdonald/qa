Given /^I have a flag on a question$/ do
  Given %q[a question exists with my flag on it]
  And %q[I go to the question's page]
end

Given /^a question exists with my flag on it$/ do
  Given %q[a question exists]
  Flag.create :user => @user, :flaggable => model!("the question")
end

