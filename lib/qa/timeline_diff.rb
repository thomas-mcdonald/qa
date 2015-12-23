module QA
  # TimelineDiff is to assist with creating the list of TimelineEvent objects.
  # Only some TimelineEvent objects have associated PostHistory objects, and these must be zipped together so they have access to previous one for diffing.
  class TimelineDiff
    attr_reader :event, :previous
    delegate :action, :created_at, :post, :post_history, :users, to: :event

    # TODO: when we start tracking events with no post diff this will need updating
    def self.generate(timeline_events)
      previous = timeline_events.to_a.dup.unshift(nil)
      timeline_events.zip(previous).map do |tuple|
        # tuple is (current_event, previous_event)
        TimelineDiff.new(tuple.first, tuple.second)
      end
    end

    def initialize(event, previous)
      Differ.format = QA::Diff::HTML
      @event = event
      @previous = previous
    end

    def title_diff
      if previous.nil?
        post_history.title
      else
        Differ.diff_by_word(post_history.title, previous.post_history.title).to_s.html_safe
      end
    end

    def body_diff
      if previous.nil?
        post_history.render_body
      else
        diff = Differ.diff_by_word(post_history.body, previous.post_history.body).to_s.html_safe
        %(<pre class="post-diff">#{diff}</pre>).html_safe
      end
    end
  end
end
