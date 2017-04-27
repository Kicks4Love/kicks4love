class FeatureUploader < ImageUploader

  version :main do
    process resize_to_limit: [300, 220]
  end

end
