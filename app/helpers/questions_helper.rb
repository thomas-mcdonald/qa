module QuestionsHelper
  def format(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, {
      autolink: true,
      fenced_code_blocks: true,
      superscript: true
    }).render(text).html_safe
  end
end