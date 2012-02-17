module BootstrapHelper
  def header(elem, heading, subheading = nil)
    subheading = "<small>#{subheading}</small>" if subheading
    %[<div class="page-header"><#{elem.to_s}>#{heading} #{subheading}</#{elem.to_s}></div>].html_safe
  end
end