# frozen_string_literal: true
require "test_helper"

class PoWTest < Minitest::Test
  def test_execute
    pow = Fairwork::PoW.new(0, 0)
    expected = '1111101100000100100010101111011111101000100100100000001010000010010011010101011110001101101011001001001100010100010101100000011100011000001011111000010000111101110111111010001110000011111110101100011011011101000010000100000100111011010000011111100011111100'
    assert_equal expected, pow.execute(0, 'GET', '/', [0] * 16, 0)
  end

  def test_solve_and_validate
    pow = Fairwork::PoW.new(0, 0)
    nounce, timestamp, uniq_ctr = pow.solve('GET', '/', 4)
    assert_equal true, pow.validate(timestamp, 'GET', '/', uniq_ctr, nounce, 4)
  end
end

class PoWBench < MiniTest::Benchmark
  def self.bench_range
    bench_exp(1, 8, 2)
  end

  def bench_solve
    pow = Fairwork::PoW.new(0, 0)

    assert_performance_exponential 0.99 do |n|
      100.times do
        pow.solve('GET', '/', n)
      end
    end
  end
end
