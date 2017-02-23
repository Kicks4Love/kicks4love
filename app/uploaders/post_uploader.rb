class PostUploader < ImageUploader

  version :general do
    process resize_to_limit: [300, 220]
  end

  version :news do
    process resize_to_limit: [940, 400]
  end

end
