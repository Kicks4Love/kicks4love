class FeatureUploader < ImageUploader

  version :image do
    process resize_to_limit: [300, 220]
  end

end
