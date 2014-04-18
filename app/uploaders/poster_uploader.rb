class PosterUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.pluralize.underscore}/#{model.id}/#{mounted_as.to_s.pluralize}"
  end

  process convert: :png

  version :small do
    process resize_to_fill: [180, 267]
  end

  version :large do
    process resize_to_fill: [900, 1000]
  end
end
