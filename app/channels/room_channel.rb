# マッチング後のプライベートルーム
class RoomChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find_by(id: params[:room_id])
    if @room.present?
      stream_for(@room)
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # サブスクライバの誰かの接続が切れたら(画面のリロードや、画面遷移)、他のメンバーに知らせる
    puts "-----------"
    puts "   #{current_user.name} unsubscribed RoomChannel:#{@room.id}"
    puts "-----------"

    # ActionCable.server.broadcast(build_room_id(message.room.id), payload)
  end

  # calls when a client broadcasts data
  # 恐らくerror発生でfalseを返す
  def speak(data)
    message   = data['message']
    raise 'No message!' if message.blank?

    msg = Message.create!(
      room: @room,
      user: current_user,
      content: message,
    )
    broadcast(msg)
  end
  
  # Helpers
  def broadcast(message)
    payload = {
      room_id: message.room.id,
      content: message.content,
      sender: current_user.name,
      participants: @room.users.collect(&:id)
    }
    self.class.broadcast_to(@room, payload)
  end
end
