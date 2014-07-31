require 'spec_helper'

describe Comment do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:post_id) }
    it { is_expected.to validate_presence_of(:post_type) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
