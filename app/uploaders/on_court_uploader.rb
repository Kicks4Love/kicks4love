class OnCourtUploader < ImageUploader

  version :cover do
    process resize_to_limit: [690, 1037]
  end

  version :main do
    process resize_to_limit: [995, 660]
  end

end
