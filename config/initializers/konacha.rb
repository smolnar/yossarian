if Rails.env.test? && defined?(Konacha)
  Konacha.configure do |config|
    require 'rspec/core/formatters/documentation_formatter'
    require 'capybara/poltergeist'

    RSpec.configure do |rspec|
      rspec.color_enabled = true
    end

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, timeout: 60)
    end

    config.driver       = :poltergeist
    config.spec_dir     = 'spec/javascripts'
    config.spec_matcher = /_spec\.|_test\./
    config.formatters   = [RSpec::Core::Formatters::DocumentationFormatter.new(STDOUT)]
    config.stylesheets  = %w(application)

    WebMock.disable! if ENV['DISABLE_WEBMOCK']
  end
end
