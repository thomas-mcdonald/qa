require 'spec_helper'

describe AnswerCreator do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  it 'does not accept nil question' do
    -> { AnswerCreator.new(nil, User.new, {}) }.should raise_error(ArgumentError)
  end

  it 'does not accept nil user' do
    -> { AnswerCreator.new(Question.new, nil, {}) }.should raise_error(ArgumentError)
  end

  it 'creates a valid answer' do
    creator = AnswerCreator.new(question, user, {
      body: 'I have nothing of interest to add to this question'
    })
    answer = creator.create
    answer.should be_valid
  end

  it 'creates the timeline events' do
    Answer.any_instance.expects(:create_timeline_events)
  end
end
