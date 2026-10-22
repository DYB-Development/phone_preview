require "uri"

module PhonePreview
  class Railtie < Rails::Railtie
    initializer "phone_preview.emailed_links", before: "action_mailer.set_configs" do |app|
      address = ENV["PUBLIC_BASE_URL"].presence

      if Rails.env.development? && address
        public_uri = URI.parse(address)
        app.config.action_mailer.default_url_options = { host: public_uri.host, protocol: public_uri.scheme }
      end
    end
  end
end
