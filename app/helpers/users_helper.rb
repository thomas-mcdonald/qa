module UsersHelper
  def reputation_formatter(number)
    case number
    when 0..9999
      number_with_delimiter(number)
    when 10000..99999
      str = number.to_s
      check = (str[0..2] + "00").to_i
      if (check % 1000) == 0
        number.to_s[0..1] + "k"
      else
        number.to_s[0..1] + "." + number.to_s[2] + "k"
      end
    else
      number.to_s[0..2] + "k"
    end
  end
end