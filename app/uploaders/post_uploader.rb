class PostUploader < ImageUploader

  version :news do
    process resize_to_limit: [300, 220]
  end

  version :post do
    process resize_to_limit: [940, 400]
  end

end
