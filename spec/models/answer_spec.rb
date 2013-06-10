require 'spec_helper'
require 'concerns/voteable_examples'

describe Answer do
  it_should_behave_like 'voteable'

  context 'accepted_is_on_question' do
    it 'does not add an error if there is no accepted_answer_id' do
      question = FactoryGirl.build(:question, accepted_answer_id: nil)
      question.should be_valid
    end

    it 'is valid if the answer id is an answer to the question' do
      answer = FactoryGirl.create(:answer)
      question = answer.question
      question.accepted_answer_id = answer.id
      question.should be_valid
    end

    it 'is not valid if the answer id is not an answer to the question' do
      question = FactoryGirl.build(:question, accepted_answer_id: 1)
      question.should_not be_valid

      question = FactoryGirl.build(:question, accepted_answer_id: 'string')
      question.should_not be_valid
    end
  end
end
