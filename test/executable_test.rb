require "test_helper"
require "open3"
require "tmpdir"
require "socket"
require "rqrcode"

class ExecutableTest < Minitest::Test
  EXECUTABLE = File.expand_path("../exe/phone_preview", __dir__)
  OFFLINE = "HTTP/1.1 404 Not Found\r\nContent-Length: 15\r\nConnection: close\r\n\r\nERR_NGROK_3200\n"

  def setup
    @address_server = TCPServer.new("127.0.0.1", 0)
    @address = "http://127.0.0.1:#{@address_server.addr[1]}"
    @address_answer = OFFLINE
    @address_thread = Thread.new do
      loop do
        client = @address_server.accept
        client.readpartial(4096)
        client.write(@address_answer)
        client.close
      end
    rescue IOError
    end
  end

  def teardown
    @address_server.close
    @address_thread.join
  end

  def free_port
    server = TCPServer.new("127.0.0.1", 0)
    server.addr[1].to_s
  ensure
    server.close
  end

  def run_with_stand_ins(env = {})
    Dir.mktmpdir do |bin|
      stand_in(bin, "overmind", %(echo "overmind $* PORT=$PORT"))
      stand_in(bin, "ngrok", %(echo "Valid configuration file at #{bin}/ngrok.yml"))
      File.write(File.join(bin, "ngrok.yml"), "version: \"3\"\nagent:\n  authtoken: token\n")
      yield bin if block_given?
      output, = Open3.capture2e({ "PATH" => bin, "PORT" => free_port, "PUBLIC_BASE_URL" => @address }.merge(env), RbConfig.ruby, EXECUTABLE)
      output
    end
  end

  def stand_in(bin, name, script)
    File.write(File.join(bin, name), "#!/bin/sh\n#{script}\n")
    File.chmod(0o755, File.join(bin, name))
  end

  def test_prints_a_qr_code_of_the_public_address_for_a_phone_camera
    assert_includes run_with_stand_ins, RQRCode::QRCode.new(@address).as_ansi
  end

  def test_runs_the_app_and_the_tunnel_from_the_app_folder_with_one_port_for_both
    procfile = File.expand_path("../lib/phone_preview/Procfile", __dir__)

    assert_includes run_with_stand_ins, "overmind start -T --no-port -f #{procfile} -d #{Dir.pwd} PORT="
  end

  def test_starts_on_port_3000_when_no_port_is_given
    assert_match(/^overmind .* PORT=3000$/, run_with_stand_ins("PORT" => nil))
  end

  def test_prints_the_public_address_to_open_on_the_phone
    assert_includes run_with_stand_ins, "Open #{@address} on your phone"
  end
end
