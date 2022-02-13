# frozen_string_literal: true
require "test_helper"

class PoWTest < Minitest::Test
  def test_execute
    pow = Fairwork::PoW.new(0)
    expected = '1111011111010100011100101000011111110001100000000100111101000010000111000101001111100111111110010011011100000101001111011010010100110101111010001010111011101110101110001100110001010011001110111001111000100111101010010000000001111001000101101000100100001101'
    assert_equal expected, pow.execute(0, 'GET', '/', 0, 0)
  end

  def test_solve_and_validate
    pow = Fairwork::PoW.new(0)
    nounce, timestamp, uniq_ctr = pow.solve('GET', '/', 4)
    assert_equal true, pow.validate(timestamp, 'GET', '/', uniq_ctr, nounce, 4)
  end
end

class PoWBench < MiniTest::Benchmark
  def self.bench_range
    bench_linear(0, 8, 1)
  end

  def bench_solve
    pow = Fairwork::PoW.new(0)

    assert_performance_exponential 0.95 do |n|
      100.times do
        pow.solve('GET', '/', n)
      end
    end
  end
end
