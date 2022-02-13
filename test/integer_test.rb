# frozen_string_literal: true
require "test_helper"

class IntegerTest < Minitest::Test
  def test_integer
    assert_equal([0xFF], 0xFF.to_bytes(:big_endian, 1))
    assert_equal([0, 0xFF], 0xFF.to_bytes(:big_endian, 2))
    assert_equal([0xFF], 0xFF.to_bytes(:little_endian, 1))
    assert_equal([0xFF, 0], 0xFF.to_bytes(:little_endian, 2))
  end
end
