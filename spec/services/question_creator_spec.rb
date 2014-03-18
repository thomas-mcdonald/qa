require 'spec_helper'

describe QuestionCreator do
  let(:user) { FactoryGirl.create(:user) }

  it 'does not accept nil user' do
    -> { QuestionCreator.new(nil, {}) }.should raise_error(ArgumentError)
  end

  it 'creates a valid question' do
    creator = QuestionCreator.new(user, {
      body: 'I have nothing of interest to add to this question',
      title: 'How do I do this thing?',
      tag_list: 'the-thing'
    })
    question = creator.create
    question.should be_valid
  end

  it 'creates the timeline events' do
    Question.any_instance.expects(:create_timeline_events)
  end
end
