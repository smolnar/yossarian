require 'spec_helper'
require 'models/concerns/recordings/buildable_spec'

describe Recording do
  it_behaves_like Recordings::Buildable

  it 'belongs to artist' do
    pending
  end

  it 'belongs to track' do
    pending
  end
end
