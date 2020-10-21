class RoomChannel < ApplicationCable::Channel
  def subscribed
    if params[:room_id].present?
      # creates a private chat room with a unique name
      stream_from("ChatRoom-#{(params[:room_id])}")
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
  end
end
