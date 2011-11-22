module QA
  module TextParser
    module Render
      # Comments use a half-arsed version of markdown. 
      class Comment < Redcarpet::Render::HTML
        # Don't wrap in <p> tags, just return the text
        def paragraph(text)
          text
        end

        # No to <hr>'s
        def hrule
          nil
        end

        # No to all sorts of block stuff
        def block_code(code, language)
          nil
        end

        def block_quote(quote)
          nil
        end
      end
    end
  end
end
