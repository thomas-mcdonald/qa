module QA
  module TextParser
    class Post < Base
      def renderer
        Redcarpet::Render::HTML.new(:no_styles => true, :safe_links_only => true)
      end
    end
  end
end
