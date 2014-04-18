module Youtube
  class Video
    def initialize(media)
      @media = media
    end

    def url
      @media.media_content.first.url
    end
  end
end
