module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search_by, lambda { |attributes, options| Composer.new(self, attributes, options).compose }
  end

  class Composer
    attr_accessor :base, :attributes, :query, :options

    def intialize(base, attributes, options)
      @base       = base
      @attributes = attributes
      @options    = options
    end

    def query
      @query ||= attributes.inject(Hash.new) do |result, (path, value)|
        if value.is_a? Hash
          values.each do |name, query|
            result[sanitize_attribute("#{path}.#{name}")] = query
          end
        else
          result[sanitize_attribute(path)] = value
        end
      end
    end

    def compose
      query.each do |name, value|
        self.base = base.where("lower(musicbrainz_unaccent(#{name})) = ")
      end
    end

    private

    def sanitize_attribute(attribute)
      attribute.gsub(/[^A-Za-z0-9_\-\.]/, '')
    end
  end
end
