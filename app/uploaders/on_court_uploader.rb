class OnCourtUploader < ImageUploader

  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :cover do
    process resize_to_limit: [690, 1037]
  end

  version :main do
    process resize_to_limit: [995, 660]
  end

end
