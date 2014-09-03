module QuestionsHelper
  def format(text)
    Pipeline.generic_render(text)
  end
end
