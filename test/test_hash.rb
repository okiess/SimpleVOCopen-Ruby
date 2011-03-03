require 'helper'
require 'logger'

class TestHash < Test::Unit::TestCase
  should 'insert/get a value' do
    assert hash["a"] = "b"
    assert_equal hash["a"], "b"
  end

  should 'update a value' do
    assert_equal hash["a"], "b"
    assert hash["a"] = "b2"
    assert_equal hash["a"], "b2"
  end

  should 'check for the existence of a key' do
    hash["x"] = "y"
    assert hash.has_key?("x")
  end

  should 'get multiple values at once' do
    hash["x"] = "y"
    hash["x2"] = "y2"
    values_hash = hash.values_at(["x", "x2"])
    assert_not_nil values_hash
    assert_equal values_hash["x"], "y"
    assert_equal values_hash["x2"], "y2"
  end

  private
  def hash
    port = ENV['SIMPLEVOC_PORT'] || '12345'
    host = ENV['SIMPLEVOC_HOST'] || 'localhost'
    @hash ||= Simplevoc::Open::Hash.new('host' => host, 'port' => port, :log_level => Logger::DEBUG)
  end
end

