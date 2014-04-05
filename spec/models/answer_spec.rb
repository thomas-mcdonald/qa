require 'spec_helper'
require 'concerns/voteable_examples'

describe Answer do
  it_should_behave_like 'voteable'

  context '#question_view_ordering' do
    let(:question) { FactoryGirl.create(:question, accepted_answer_id: nil) }
    let(:a1) { FactoryGirl.create(:answer, question: question) }
    let(:a2) { FactoryGirl.create(:answer, question: question) }

    before do
      # create an upvote on a2
      VoteCreator.new(FactoryGirl.create(:user), post_id: a2.id, post_type: 'Answer', vote_type: 'upvote').create
    end

    it 'orders by vote as per usual if there is no accepted answer' do
      question.answers.question_view_ordering(question).should == [a2, a1]
    end

    it 'pulls out the accepted answer first if there is an accept answer' do
      question.accepted_answer_id = a1.id
      question.save
      question.answers.question_view_ordering(question).should == [a1, a2]
    end
  end
end