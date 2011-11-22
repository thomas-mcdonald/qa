module QA
  module TextParser
    class Base
      include Rails.application.routes.url_helpers

      def initialize(text)
        @text = text
      end

      def format
        markdown
        extract_tags
        @text.html_safe
      end

      def markdown
        @text = Redcarpet::Markdown.new(renderer).render(@text)
      end

      def renderer
        raise NotImplementedError
      end

      def extract_tags
        matches = @text.scan /\[tag:(\S+)\]/
        matches.each do |m|
          @text.gsub! "[tag:#{m[0]}]", %(<a href="#{tagged_questions_path(m[0])}" class="btn tag">#{m[0]}</a>)
        end
      end
    end
  end
end
