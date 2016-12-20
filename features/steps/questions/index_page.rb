class Spinach::Features::IndexPage < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedQuestion

  step 'I visit the new index page' do
    visit '/new_index'
  end

  step 'I should see those questions' do
    current_questions.each do |question|
      assert page.has_css?('.qa-question-list-title', text: question.title)
    end
  end
end
