if defined?(CarrierWave)
  CarrierWave::Uploader::Base.descendants.each do |uploader|
    next if uploader.anonymous?

    uploader.class_eval do
      def cache_dir
        "#{Rails.root}/spec/support/uploads/tmp"
      end

      def store_dir
        "#{Rails.root}/spec/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
end
