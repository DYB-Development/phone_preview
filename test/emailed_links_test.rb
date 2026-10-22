require "test_helper"
require "open3"

class EmailedLinksTest < Minitest::Test
  APP = <<~RUBY
    require "bundler/setup"
    require "rails"
    require "action_mailer/railtie"
    require "phone_preview"

    class App < Rails::Application
      config.eager_load = false
      config.logger = Logger.new(nil)
      config.secret_key_base = "test"
      config.action_mailer.default_url_options = { host: "lvh.me", port: 3000 }
    end

    App.initialize!
    puts ActionMailer::Base.default_url_options.sort.to_h
  RUBY

  def link_options(env)
    output, = Open3.capture2e({ "RAILS_ENV" => "development" }.merge(env), RbConfig.ruby, "-I", File.expand_path("../lib", __dir__), "-e", APP)
    output.lines.last.to_s.strip
  end

  def test_emailed_links_use_the_public_address_over_https_with_no_port_when_it_is_set
    assert_equal({ host: "app-dev.ngrok.app", protocol: "https" }.to_s, link_options("PUBLIC_BASE_URL" => "https://app-dev.ngrok.app"))
  end

  def test_emailed_links_keep_the_app_s_own_host_and_port_when_no_public_address_is_set
    assert_equal({ host: "lvh.me", port: 3000 }.to_s, link_options("PUBLIC_BASE_URL" => nil))
  end

  def test_emailed_links_keep_the_app_s_own_host_and_port_outside_development
    assert_equal({ host: "lvh.me", port: 3000 }.to_s, link_options("PUBLIC_BASE_URL" => "https://app-dev.ngrok.app", "RAILS_ENV" => "production"))
  end
end
