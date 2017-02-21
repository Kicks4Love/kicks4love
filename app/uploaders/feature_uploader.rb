class FeatureUploader < ImageUploader

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :image do
    process resize_to_limit: [300, 220]
  end

end