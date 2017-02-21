class PostUploader < ImageUploader

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :general do
    process resize_to_limit: [300, 220]
  end

  version :news do
    process resize_to_limit: [940, 400]
  end

end