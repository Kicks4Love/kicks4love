class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def size_range
    if Rails.env.production?
      0..150.kilobytes
    end
  end

  process resize_to_limit: [800, 800]

end