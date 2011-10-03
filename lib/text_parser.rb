module QA
  class TextParser
    def initialize(text)
      @text = text
    end

    def format
      self.markdown.html_safe
    end

    def markdown
      Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(@text)
    end
  end
end
