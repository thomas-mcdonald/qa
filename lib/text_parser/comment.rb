module QA
  module TextParser
    class Comment < Base
      def renderer
        QA::TextParser::Render::Comment.new(:no_images => true, :no_styles => true, :safe_links_only => true)
      end
    end
  end
end
