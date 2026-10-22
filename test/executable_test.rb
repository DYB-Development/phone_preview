require "test_helper"
require "open3"
require "tmpdir"
require "rqrcode"

class ExecutableTest < Minitest::Test
  EXECUTABLE = File.expand_path("../exe/phone_preview", __dir__)
  ADDRESS = "https://app-dev.ngrok.app"

  def run_with_stand_in_overmind(env = { "PUBLIC_BASE_URL" => ADDRESS })
    Dir.mktmpdir do |bin|
      File.write(File.join(bin, "overmind"), "#!/bin/sh\necho \"overmind $* PORT=$PORT\"\n")
      File.chmod(0o755, File.join(bin, "overmind"))
      output, = Open3.capture2e({ "PATH" => "#{bin}:#{ENV["PATH"]}", "PORT" => nil }.merge(env), RbConfig.ruby, EXECUTABLE)
      output
    end
  end

  def test_prints_a_qr_code_of_the_public_address_for_a_phone_camera
    assert_includes run_with_stand_in_overmind, RQRCode::QRCode.new(ADDRESS).as_ansi
  end

  def test_runs_the_app_and_the_tunnel_from_the_app_folder_with_one_port_for_both
    procfile = File.expand_path("../lib/phone_preview/Procfile", __dir__)

    assert_includes run_with_stand_in_overmind, "overmind start -T --no-port -f #{procfile} -d #{Dir.pwd} PORT="
  end

  def test_starts_on_port_3000_when_no_port_is_given
    assert_match(/^overmind .* PORT=3000$/, run_with_stand_in_overmind)
  end

  def test_prints_the_public_address_to_open_on_the_phone
    assert_includes run_with_stand_in_overmind, "Open #{ADDRESS} on your phone"
  end
end
