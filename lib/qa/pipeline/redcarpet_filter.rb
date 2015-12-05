module QA
  module Pipeline
    class RedcarpetFilter < HTML::Pipeline::TextFilter
      def initialize(text, context = nil, result = nil)
        super(text, context, result)
        @text = @text.delete("\r")
      end

      def call
        Redcarpet::Markdown.new(Redcarpet::Render::HTML, {
          autolink: true,
          fenced_code_blocks: true,
          superscript: true
        }).render(@text)
      end
    end
  end
end