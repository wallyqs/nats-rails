class Message < ApplicationRecord
  extend ActiveModel::Callbacks
  attr_accessor :data

  # define_model_callbacks :create

  # def create
  #   run_callbacks(:create) do
  #     p :updateddddddddddddddddddddddddddd
  #   end
  # end
end
