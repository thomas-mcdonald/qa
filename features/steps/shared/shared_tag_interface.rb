# Interacting with selectize.js and Capybara is not the easiest.
# This adds a couple of helper methods used in the test codebase
module SharedTagInterface
  # TODO: check this is actually typing tags in as expected
  #       may need to split input
  def input_tags(tag_list)
    find('.selectize-control input').set(tag_list)
  end

  def input_and_add_tags(tag_list)
    input_tags(tag_list)
    within '.selectize-dropdown' do
      find('.create').click
    end
  end

  def remove_tag
    find('.selectize-control input').native.send_key(:Backspace)
  end
end
