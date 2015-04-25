class Spinach::Features::TagAutocomplete < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedTagInterface

  step 'there exists some tags' do
    FactoryGirl.create(:question, tag_list: 'tag1, tag2, tag3, test')
  end

  step 'I type the beginning of a tag' do
    input_tags('tag')
  end

  step 'I type a new tag' do
    input_tags('not-even-close')
  end

  step 'I should see the tag suggested in a dropdown' do
    within '.selectize-dropdown' do
      assert_text 'tag1'
      assert_text 'tag2'
      assert_text 'tag3'
      refute_text 'test'
    end
  end

  step 'I should see a link to create the new tag' do
    within '.selectize-dropdown' do
      refute_text 'tag1'
      assert_text 'not-even-close'
    end
  end
end
