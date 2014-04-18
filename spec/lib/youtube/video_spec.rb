require 'spec_helper'

describe Youtube::Video do
  it 'correctly initializes music video' do
    media = double(:media, url: 'http://url')
    data  = double(:data, media_content: [media])

    trailer = Youtube::Video.new(data)

    expect(trailer.url).to eql('http://url')
  end
end
