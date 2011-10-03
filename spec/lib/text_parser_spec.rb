require 'spec_helper'

describe QA::TextParser do
  describe "tag extraction" do
    it "should be able to extract multiple tags" do
      string = "[tag:foo] [tag:bar]"
      result = QA::TextParser.new(string).format
      result.should include(%(<a href="/questions/tagged/foo" class="btn tag">foo</a>))
      result.should include(%(<a href="/questions/tagged/bar" class="btn tag">bar</a>))
    end
  end
end
