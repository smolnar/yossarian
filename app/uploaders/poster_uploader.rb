class PosterUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def filename
    "#{mounted_as}.png" if original_filename
  end

  def store_dir
    "#{model.class.to_s.pluralize.underscore}/#{model.id}"
  end

  process convert: :png

  version :small do
    process resize_to_fill: [180, 267]
  end

  version :large do
    process resize_to_fill: [900, 1000]
  end
end
