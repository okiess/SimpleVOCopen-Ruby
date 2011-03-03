require 'helper'
require 'logger'

class TestNonStrictClient < Test::Unit::TestCase
  should "insert value for key a" do
    assert client.flush
    assert client.insert("a", "b")
  end

  should 'fail inserting value when the value is empty' do
    assert !client.insert('a', nil)
  end

  should 'fail inserting value when the key is empty' do
    assert !client.insert(nil, nil)
  end

  should "fail inserting value for key a when value for key a exists" do
    assert !client.insert('a', 'b')
  end

  should "insert or update value for key c" do
    assert !client.get('c')

    assert client.insert_or_update('c', 'd')
    sv_response = client.get('c')
    assert_not_nil sv_response
    assert_equal sv_response['value'], 'd'

    assert client.insert_or_update('c', 'd2')
    sv_response = client.get('c')
    assert_not_nil sv_response
    assert_equal sv_response['value'], 'd2'
  end

  should 'fail creating or updating value when the value is empty' do
    assert !client.insert_or_update('a', nil)
  end

  should 'fail creating or updating value when the key is empty' do
    assert !client.insert_or_update(nil, nil)
  end

  should 'fail when trying to update a value for a missing key' do
    assert !client.update('a2', 'b2')
  end

  should 'fail updating when the value is empty' do
    assert !client.update('a2', nil)
  end

  should 'fail updating when the key is empty' do
    assert !client.update(nil, nil)
  end

  should 'delete a value for a key' do
    assert_nil client.get('d')

    assert client.insert('d', 'e')

    sv_response = client.get('d')
    assert_equal sv_response['value'], 'e'
    assert client.delete('d')

    assert_nil client.get('d')
  end

  should 'fail deleting when the key does not exist' do
   assert !client.delete('d2')
  end

  should 'fail deleting when the key is empty' do
    assert !client.delete(nil)
  end

  should 'fail getting when the key does not exist' do
    assert !client.get('e2')
  end

  should 'fail getting when the key is empty' do
    assert !client.get(nil)
  end

  should 'flush all keys' do
    assert client.insert('h', 'i')
    assert_equal client.get('h', false), 'i'
    assert client.flush
    assert !client.get('h')
  end

  should 'fail when a no key for a given prefix can be found' do
    assert_nil = client.keys('test')
  end

  private
  def client
    port = ENV['SIMPLEVOC_PORT'] || '12345'
    host = ENV['SIMPLEVOC_HOST'] || 'localhost'
    @client ||= Simplevoc::Open::Client.new('host' => host, 'port' => port, 'log_level' => Logger::DEBUG, 'strict_mode' => false)
  end
end

