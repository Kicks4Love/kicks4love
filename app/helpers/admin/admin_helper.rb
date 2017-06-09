module Admin::AdminHelper

  def self.trim_str(string)
    return string if string.empty? || string.length < 2
    return string.delete(">>").strip
  end

  def trim_str(string)
    return AdminHelper.trim_str(string)
  end

end