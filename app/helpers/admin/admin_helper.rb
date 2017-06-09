module Admin::AdminHelper

	def self.trim_str(string)
	    return string if string.empty? || string.length < 2
	    return string.delete(">>").strip
	end

	def self.remove_uploads_file(post_type, id)
		FileUtils.rm_r Rails.public_path.join("uploads/#{post_type}/#{id}")
	end

end