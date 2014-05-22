require 'spec_helper'
require 'models/concerns/artist/buildable_spec'

describe Artist do
  it_behaves_like Artist::Buildable

  it 'stores image' do
    DownloaderService.stub(:fetch) { fixture('poster.jpg') }

    artist = create :artist

    expect(artist.image.file).not_to be_nil
  end

  context 'when no image is available' do
    it 'does not store image' do
      DownloaderService.stub(:fetch) { nil }

      artist = create :artist

      expect(artist.image.file).to be_nil
    end
  end
end
