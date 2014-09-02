require_dependency 'redcarpet_filter'

module QuestionsHelper
  def format(text)
    HTML::Pipeline.new([RedcarpetFilter], {}).call(text)[:output].html_safe
  end
end