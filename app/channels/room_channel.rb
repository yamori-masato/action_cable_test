# マッチング後のプライベートルーム
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

  # calls when a client broadcasts data
  # 恐らくerror発生でfalseを返す
  def speak(data)
    sender    = current_user
    room_id   = data['room_id']
    message   = data['message']

    raise 'No room_id!' if room_id.blank?
    room = get_room(room_id) # A room is a room
    raise 'No room found!' if room.blank?
    raise 'No message!' if message.blank?

    # adds the message sender to the room if not already included
    room.users << sender unless room.users.include?(sender)
    # saves the message and its data to the DB
    # Note: this does not broadcast to the clients yet!
    msg = Message.create!(
      room: room,
      user: sender,
      content: message
    )
    broadcast(msg)
  end
  
  # Helpers
  
  def get_room(room_id)
    Room.find_by(id: room_id)
  end

  def broadcast(message)
    payload = {
      room_id: message.room.id,
      content: message.content,
      sender: message.user,
      participants: message.room.users.collect(&:id)
    }
    ActionCable.server.broadcast(build_room_id(message.room.id), payload)
  end

  def build_room_id(id)
    "ChatRoom-#{id}"
  end
end
