if defined?(CarrierWave)
  [ImageUploader, PosterUploader].each do |uploader|
    next if uploader.anonymous?

    uploader.class_eval do
      def cache_dir
        "#{Rails.root}/tmp/spec/uploads"
      end

      def store_dir
        "#{Rails.root}/tmp/spec/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
end
