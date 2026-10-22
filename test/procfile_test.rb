require "test_helper"

class ProcfileTest < Minitest::Test
  PROCFILE = File.expand_path("../lib/phone_preview/Procfile", __dir__)

  def test_runs_the_rails_server_and_a_tunnel_from_the_public_address_to_its_port
    processes = File.readlines(PROCFILE, chomp: true).reject(&:empty?).to_h { |line| line.split(": ", 2) }

    assert_equal({ "web" => "bin/rails server -p $PORT", "tunnel" => "ngrok http --url=$PUBLIC_BASE_URL $PORT --log=stdout" }, processes)
  end
end
