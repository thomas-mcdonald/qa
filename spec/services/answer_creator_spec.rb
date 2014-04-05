require 'spec_helper'

describe AnswerCreator do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }
  mock_data = {
    body: 'I have nothing of interest to add to this question'
  }

  it 'does not accept nil question' do
    -> { AnswerCreator.new(nil, User.new, {}) }.should raise_error(ArgumentError)
  end

  it 'does not accept nil user' do
    -> { AnswerCreator.new(Question.new, nil, {}) }.should raise_error(ArgumentError)
  end

  it 'creates a valid answer' do
    creator = AnswerCreator.new(question, user, mock_data)
    answer = creator.create
    answer.should be_valid
  end

  it 'sets the user' do
    creator = AnswerCreator.new(question, user, mock_data.merge(user_id: 99999))
    answer = creator.create
    answer.user_id.should == user.id
  end

  it 'creates the timeline events' do
    Answer.any_instance.expects(:create_timeline_event!)
    AnswerCreator.new(question, user, mock_data).create
  end
end
