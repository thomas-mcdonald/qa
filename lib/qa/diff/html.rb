module QA
  module Diff
    # QA::Diff::HTML overrides Differ::Format::HTML to output a different set of HTML tags.
    module HTML
      class << self
        def format(change)
          (change.change? && as_change(change)) ||
          (change.delete? && as_delete(change)) ||
          (change.insert? && as_insert(change)) ||
          ''
        end

        private

        def as_insert(change)
          %Q{<span class="ins">#{change.insert}</span>}
        end

        def as_delete(change)
          %Q{<span class="del">#{change.delete}</span>}
        end

        def as_change(change)
          as_delete(change) << as_insert(change)
        end
      end
    end
  end
end
