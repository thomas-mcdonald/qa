require 'spec_helper'

shared_examples_for 'TimelineAction' do
  # create the appropriate post object for the class mixing in these examples
  let(:post) { FactoryGirl.create(described_class.name.gsub('sController', '').downcase) }

  context 'GET timeline' do
    before { get :timeline, id: post.id }
    it { should respond_with(:success) }
    it { should render_template('posts/timeline')}
  end
end