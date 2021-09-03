require 'nats/io/client'

module NATS
  class << self
    attr_writer :connection
  end

  def self.connection
    @connection ||= NATS.connect("nats://localhost:4222")
  end
end

NATS.connection.on_error do |e|
  puts "Error: #{e}"
end
