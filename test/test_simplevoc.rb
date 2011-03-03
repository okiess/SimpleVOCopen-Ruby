require 'helper'
require "ftools"

class TestSimplevoc < Test::Unit::TestCase
  should "initialize configuration" do
    client = Simplevoc::Open::Client.new('protocol' => 'http', 'host' => 'localhost', 'port' => '12345',
                                   'log_level' => Logger::DEBUG, 'strict_mode' => true)
    assert_not_nil client
    assert_not_nil client.configuration
    assert_not_nil client.configuration.options
    assert_not_nil client.logger

    assert_equal client.configuration.options['protocol'], 'http'
    assert_equal client.configuration.options['host'], 'localhost'
    assert_equal client.configuration.options['port'], '12345'
    assert_equal client.configuration.options['log_level'], Logger::DEBUG
    assert client.configuration.options['strict_mode']
  end

  should "return correct server base url based on configuration" do
    client = Simplevoc::Open::Client.new('host' => 'localhost', 'port' => '12345')
    assert_equal client.send(:base_url), 'http://localhost:12345'

    client2 = Simplevoc::Open::Client.new('protocol' => 'https', 'host' => 'localhost', 'port' => '8080')
    assert_equal client2.send(:base_url), 'https://localhost:8080'
  end

  should 'initialize configuration from yml file from current directory' do
    client = Simplevoc::Open::Client.new
    assert_equal client.configuration.options['protocol'], 'http'
    assert_equal client.configuration.options['host'], 'localhost'
    assert_equal client.configuration.options['port'], '12345'
    assert client.configuration.options['strict_mode']
  end

  should "read configuration" do
    assert_not_nil (client = Simplevoc::Open::Client.new)
    File.copy('test/config.yml', './config.yml')
    client.send(:read_configuration)
    assert_not_nil client.configuration
    File.delete('./config.yml')
  end

  should "set the strict mode" do
    client = Simplevoc::Open::Client.new('host' => 'localhost', 'port' => '12345', 'strict_mode' => true)
    assert client.send(:use_strict_mode?)
    client = Simplevoc::Open::Client.new('host' => 'localhost', 'port' => '12345', 'strict_mode' => false)
    assert !client.send(:use_strict_mode?)
  end

  should 'return client version' do
    assert_equal Simplevoc::Open::Client::VERSION, '1.0.0'
  end
end
