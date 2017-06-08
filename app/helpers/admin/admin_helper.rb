module Admin::AdminHelper
  def self.trim_str(string)
		if string.empty? || string.length < 2
			return string
		end
		if string[0..1] == ">>"
			string = string[2..-1]
		end
		return string.strip
	end

  def trim_str(string)
    return AdminHelper.trim_str(string)
  end
end
