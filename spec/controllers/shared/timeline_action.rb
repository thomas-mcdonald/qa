require 'spec_helper'

shared_examples_for 'TimelineAction' do
  # create the appropriate post object for the class mixing in these examples
  let(:post) { FactoryGirl.create(described_class.name.gsub('sController', '').downcase) }

  context 'GET timeline' do
    before { get :timeline, params: { id: post.id }}
    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template('posts/timeline')}
  end
end
