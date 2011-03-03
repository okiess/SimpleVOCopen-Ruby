require 'helper'
require 'logger'

class TestClient < Test::Unit::TestCase
  should "fail to connect" do
    my_client = Simplevoc::Open::Client.new('host' => 'localhost', 'port' => '111111111')
    assert_raise Simplevoc::Open::ConnectionRefusedException do
      my_client.insert('a', 'b')
    end
  end

  should "insert value for key a" do
    assert client.flush
    assert client.insert("a", "b")

    sv_response = client.get("a")
    assert_equal sv_response.class, Hash
    assert_not_nil sv_response['value']
    assert_equal sv_response['value'], 'b'

    sv_response = client.get('a', false)
    assert_equal sv_response, 'b'

    assert_raise Simplevoc::Open::ValueExistsException do
      client.insert('a', 'b')
    end
  end

  should 'fail inserting value when the value is empty' do
    assert_raise Simplevoc::Open::EmptyValueException do
      client.insert('a', nil)
    end
  end

  should 'fail inserting value when the key is empty' do
    assert_raise Simplevoc::Open::EmptyKeyException do
      client.insert(nil, nil)
    end
  end

  should 'insert value for key b with extended value from hash' do
    assert client.insert_with_extended_values('b', 'c', {'name' => 'testvalue'})

    sv_response = client.get("b")
    assert_equal sv_response.class, Hash
    assert_not_nil sv_response['value']
    assert_equal sv_response['value'], 'c'
    assert_not_nil sv_response['created']
    assert_not_nil sv_response['flags']
    assert_not_nil sv_response['extended-values']
    assert sv_response['extended-values'].class, Hash
    assert_not_nil sv_response['extended-values']['name']
    assert_equal sv_response['extended-values']['name'], 'testvalue'
  end

  should 'fail inserting unknown extended key value' do
    assert client.insert_with_extended_values('b2', 'c', '{"name2":"testvalue"}')

    sv_response = client.get("b2")
    assert_equal sv_response.class, Hash
    assert_not_nil sv_response['extended-values']
    assert_nil sv_response['extended-values']['name']
  end

  should "insert or update value for key c" do
    assert_raise Simplevoc::Open::KeyNotFoundException do
      client.get('c')
    end

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
    assert_raise Simplevoc::Open::EmptyValueException do
      client.insert_or_update('a', nil)
    end
  end

  should 'fail creating or updating value when the key is empty' do
    assert_raise Simplevoc::Open::EmptyKeyException do
      client.insert_or_update(nil, nil)
    end
  end

  should "update value for key a" do
    assert client.update('a', 'c')
    sv_response = client.get('a')
    assert_equal sv_response['value'], 'c'
  end

  should 'fail when trying to update a value for a missing key' do
    assert_raise Simplevoc::Open::KeyNotFoundException do
      client.update('a2', 'b2')
    end
  end

  should 'fail updating when the value is empty' do
    assert_raise Simplevoc::Open::EmptyValueException do
      client.update('a2', nil)
    end
  end

  should 'fail updating when the key is empty' do
    assert_raise Simplevoc::Open::EmptyKeyException do
      client.update(nil, nil)
    end
  end

  should 'delete a value for a key' do
    assert_raise Simplevoc::Open::KeyNotFoundException do
      client.get('d')
    end

    assert client.insert('d', 'e')

    sv_response = client.get('d')
    assert_equal sv_response['value'], 'e'
    assert client.delete('d')

    assert_raise Simplevoc::Open::KeyNotFoundException do
      client.get('d')
    end
  end

  should 'fail deleting when the key does not exist' do
    assert_raise Simplevoc::Open::KeyNotFoundException do
      client.delete('d2')
    end
  end

  should 'fail deleting when the key is empty' do
    assert_raise Simplevoc::Open::EmptyKeyException do
      client.delete(nil)
    end
  end

  should 'get response hash with value for key e' do
    assert client.insert('e', 'f')

    sv_response = client.get('e')
    assert_equal sv_response['value'], 'f'
    assert_not_nil sv_response['created']
    assert_not_nil sv_response['flags']
  end

  should 'get value only for key f' do
    assert client.insert('f', 'g')
    assert_equal client.get('f', false), 'g'
  end

  should 'fail getting when the key does not exist' do
    assert_raise Simplevoc::Open::KeyNotFoundException do
      client.get('e2')
    end
  end

  should 'fail getting when the key is empty' do
    assert_raise Simplevoc::Open::EmptyKeyException do
      client.get(nil)
    end
  end

  should 'get keys for a given prefix' do
    assert client.insert('g', 'h')
    assert client.insert('gg', 'hh')
    assert client.insert('ggg', 'ggg')

    keys = client.keys('g')
    assert_not_nil keys
    assert_equal keys.size, 3
    assert keys.include?('g')
    assert keys.include?('gg')
    assert keys.include?('ggg')

    keys = client.keys('gg')
    assert_not_nil keys
    assert_equal keys.size, 2
    assert keys.include?('gg')
    assert keys.include?('ggg')

    keys = client.keys('ggg')
    assert_not_nil keys
    assert_equal keys.size, 1
    assert keys.include?('ggg')
  end

  should 'fail when a no key for a given prefix can be found' do
    assert_raise Simplevoc::Open::PrefixNotFoundException do
      client.keys('test')
    end
  end

  should 'flush all keys' do
    assert client.insert('h', 'i')
    assert_equal client.get('h', false), 'i'
    assert client.flush
    assert_raise Simplevoc::Open::KeyNotFoundException do
      client.get('h')
    end
    # I know this doesn't really prove the flushing...
  end

  should 'get the server version number' do
    assert_not_nil client.server_version
  end

  should 'get the server info including version number' do
    info = client.server_info
    assert_not_nil info
    assert_not_nil info['version']
    assert_not_nil info['server']
  end

  should 'create a correct header options hash' do
    test_date_time_object = Time.now.utc.iso8601
    extra_options = client.extra_options(test_date_time_object, 1, test_date_time_object, test_date_time_object)
    assert_not_nil extra_options
    assert extra_options.include?(:headers)
    assert_equal extra_options[:headers]['x-voc-expires'], test_date_time_object.to_s
    assert_equal extra_options[:headers]['x-voc-flags'], "1"
    assert_equal extra_options[:headers]['x-voc-delete-time'], test_date_time_object.to_s
    assert_equal extra_options[:headers]['x-voc-flush-delay'], test_date_time_object.to_s
  end

  private
  def client
    port = ENV['SIMPLEVOC_PORT'] || '12345'
    host = ENV['SIMPLEVOC_HOST'] || 'localhost'
    @client ||= Simplevoc::Open::Client.new('host' => host, 'port' => port, 'log_level' => Logger::DEBUG, 'strict_mode' => true)
  end
end

