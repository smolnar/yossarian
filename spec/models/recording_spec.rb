require 'spec_helper'
require 'models/concerns/recording/buildable_spec'

describe Recording do
  it_behaves_like Recording::Buildable

  it 'belongs to artist' do
    pending
  end

  it 'belongs to track' do
    pending
  end
end
