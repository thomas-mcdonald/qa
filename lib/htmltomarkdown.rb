# coding: utf-8

require "nokogiri"

module QA
  class RestoreMarkdown
    def parse(string)
      @result = ""
      doc = Nokogiri::HTML(string)
      doc.children.each do |node|
        next if node.class == Nokogiri::XML::DTD
        parse_element(node)
      end
      @result
    end

    def parse_element(element)
      return element.to_s if element.class == Nokogiri::XML::Text
      case element.node_name
      when "html"
        @result = recursive_parse(element.children)
      when "body"
        recursive_parse(element.children)
      when "p"
        recursive_parse(element.children)
      when "em"
        "*#{recursive_parse(element.children)}*"
      when "strong"
        "**#{recursive_parse(element.children)}**"
      when "ol"
        @ol_counter = 0
        recursive_parse(element.children)
      when "ul"
        "#{recursive_parse(element.children)} \n"
      when "li"
        " * #{recursive_parse(element.children)}"
      when "pre"
        recursive_parse(element.children)
      when "code"
        if element.parent.node_name == "pre"
          element.children.inner_text.split("\n").collect { |text| "    #{text}"}.join("\n")
        else
          "`#{recursive_parse(element.children)}`"
        end
      when "hr"
        "***\n"
      else
        puts element
      end
    end

    def recursive_parse(elements)
      elements.collect { |e| parse_element(e) }.join("")
    end
  end
end

puts QA::RestoreMarkdown.new.parse(string)

