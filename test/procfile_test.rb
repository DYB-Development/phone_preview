require "test_helper"
require "open3"
require "tmpdir"

class ProcfileTest < Minitest::Test
  PROCFILE = File.expand_path("../lib/phone_preview/Procfile", __dir__)

  def processes
    File.readlines(PROCFILE, chomp: true).reject(&:empty?).to_h { |line| line.split(": ", 2) }
  end

  def test_runs_the_rails_server_on_its_port
    assert_equal "bin/rails server -p $PORT", processes["web"]
  end

  def test_runs_a_tunnel_from_the_public_address_to_the_port
    assert processes["tunnel"].start_with?("ngrok http --url=$PUBLIC_BASE_URL $PORT --log=stdout")
  end

  def test_says_the_phone_can_no_longer_reach_the_app_when_the_tunnel_stops
    output = Dir.mktmpdir do |bin|
      File.write(File.join(bin, "ngrok"), "#!/bin/sh\nexit 1\n")
      File.chmod(0o755, File.join(bin, "ngrok"))
      Open3.capture2e({ "PATH" => "#{bin}:/usr/bin:/bin" }, "sh", "-c", processes["tunnel"]).first
    end

    assert_includes output, "The tunnel stopped, so the phone can no longer reach the app."
  end
end
