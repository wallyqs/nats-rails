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

Rails.configuration.after_initialize do
  # Initialize the requestor.
  begin
    NATS.connection.request("no.responders", "empty", timeout: 1)
  rescue => e
    p e
  end

  NATS.connection.subscribe("foo") do |data, reply|
    puts "[#{Thread.current.object_id}] :: GOT       : #{data} || #{reply}"
    a = Time.now
    msg = Message.find_or_create_by!(data: data)
    b = Time.now
    duration = b - a
    puts "[#{Thread.current.object_id}] :: STORED MSG: #{msg.id} #{msg.data} ::: #{duration}"
    NATS.connection.publish(reply, "OKOK!!!")
  end
end
