require_dependency 'redcarpet_filter'

module QuestionsHelper
  def format(text)
    HTML::Pipeline.new([
      RedcarpetFilter,
      HTML::Pipeline::SanitizationFilter
    ], {}).call(text)[:output].to_s.html_safe
  end
end