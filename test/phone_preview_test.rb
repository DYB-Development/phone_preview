require "test_helper"

class PhonePreviewTest < Minitest::Test
  def test_has_a_version
    refute_nil PhonePreview::VERSION
  end
end
