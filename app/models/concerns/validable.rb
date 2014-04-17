module Validable
  extend ActiveSupport::Concern

  module ClassMethods
    def validable?(attributes)
      instance = new

      instance.attributes = attributes

      instance.valid?
    end
  end
end
