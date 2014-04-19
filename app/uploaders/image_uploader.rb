class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def filename
    "#{mounted_as}.png"
  end

  def store_dir
    "#{model.class.to_s.pluralize.underscore}/#{model.id}"
  end

  process convert: :png

  version :small do
    process resize_to_fill: [200, 200]
  end

  version :large do
    process resize_to_fill: [1000, 1000]
  end
end
