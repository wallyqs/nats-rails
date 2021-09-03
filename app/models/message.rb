class Message < ApplicationRecord
  extend ActiveModel::Callbacks
  attr_accessor :data

  after_commit :make_request, on: :create
  
  def make_request
    Message.transaction do |o|
      msg = Message.find(rand(Message.all.count))
      begin
        resp = NATS.connection.old_request("foo", "bar", timeout: 2)
        Rails.logger.info ">>>>>>>>>>> Thread:#{Thread.current.object_id} >>>>>>>>>>>>>>>> #{msg} --- Got: #{resp}"
        msg.data = resp.data
        msg.save!
      rescue => e
        Rails.logger.error "ERROR!!! #{e}"
      end
    end
  end
end
