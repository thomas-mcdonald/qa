class Spinach::Features::TagAutocomplete < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths

  step 'there exists some tags' do
    FactoryGirl.create(:question, tag_list: 'tag1, tag2, tag3, test')
  end

  step 'I type the beginning of a tag' do
    find('.selectize-control input').set('tag')
  end

  step 'I type a new tag' do
    find('.selectize-control input').set('not-even-close')
  end

  step 'I should see the tag suggested in a dropdown' do
    within '.selectize-dropdown' do
      should have_content('tag1')
      should have_content('tag2')
      should have_content('tag3')
      should_not have_content('test')
    end
  end

  step 'I should see a link to create the new tag' do
    within '.selectize-dropdown' do
      should_not have_content('tag1')
      should have_content('not-even-close')
    end
  end
end
