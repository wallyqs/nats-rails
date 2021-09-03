class Message < ApplicationRecord
  extend ActiveModel::Callbacks
  attr_accessor :data

  after_commit :make_request, on: :create
  
  def make_request
    Message.transaction do
      begin
        resp = NATS.connection.request "foo", "bar"
        Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>> Got: #{resp}"
      rescue => e
        Rails.logger.error "ERROR!!! #{e}"
      end
    end
  end
end
