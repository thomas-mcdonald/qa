module CountsHelper
  def mini_count(count, string, opts = {})
    plural = string.pluralize(opts[:with] || count)
    %(<div class="mini-count"><div class="num">#{count}</div><div>#{plural}</div></div>).html_safe
  end

  def views_formatted(count)
    units = { thousand: 'k', million: 'm', billion: 'b' }
    options = { format: '%n%u', units: units }
    case count
    when 0..999
      count.to_s
    when 1000..9999
      number_to_human(count, options.merge(precision: 1))
    when 10000..99999
      number_to_human(count, options.merge(precision: 2))
    when 100_000..999_999
      number_to_human(count, options.merge(precision: 3))
    when 1_000_000..9_999_999
      number_to_human(count, options.merge(precision: 1))
    else
      # TODO: might as well work on cases up to ridiculous numbers I guess
      # 'k' version should be easy to adapt up to 1m.. might not even need changing
      count
    end
  end

  def rep_formatted(count)
    negative = ->(x) { x < 0 }
    large = ->(x) { x > 999999 }
    case count
    when 0..999
      count.to_s
    when 1000..9999
      number_with_delimiter(count).to_s
    when 10000..99999
      tmp = (count / 100).to_s
      if tmp[2] == "0"
        tmp[0..1] + "k"
      else
        tmp[0..1] + "." + tmp[2] + "k"
      end
    when 100000..999999
      (count / 1000).to_s << "k"
    when large
      "> 1m"
    when negative
      count.to_s
    end
  end
end