module Admin::AdminHelper

  def self.trim_str(string)
    return string if string.empty? || string.length < 2
    string = string[2..-1] if string[0..1] == ">>"
    return string.strip
  end

  def trim_str(string)
    return AdminHelper.trim_str(string)
  end

end