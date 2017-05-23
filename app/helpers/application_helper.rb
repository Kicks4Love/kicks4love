module ApplicationHelper

	def serialized_array_string_to_array(serialized_array_string)
		return if serialized_array_string.nil?
		serialized_array_string.split(/\r?\n/)[1..-1].collect {|content| content[2..-1]}
	end

end