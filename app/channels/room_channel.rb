# マッチング後のプライベートルーム
class RoomChannel < ApplicationCable::Channel
  def subscribed
    @room = current_user.rooms.find_by(id: params[:room_id]) # 所属していないグループとの接続は不可(Roomに属するuserをdb上で削除すれば、実質サーバ側からクライアントをkickすることが可能)
    if @room.present?
      stream_for(@room)
    else
      reject # clientのrejectedコールバックが呼ばれる
    end
  end

  def unsubscribed
    # サブスクライバの誰かの接続が切れたら(画面のリロードや、画面遷移)、他のメンバーに知らせる
    # reject後も呼ばれるので、@room=nilに注意
    # puts "-----------"
    # puts "   #{current_user.name} unsubscribed RoomChannel:#{@room.id}"
    # puts "-----------"
    # stop_all_streams
  end

  # 恐らくerror発生でfalseを返す
  def speak(data)
    message   = data['message']
    raise 'No message!' if message.blank?

    msg = Message.create!(
      room: @room,
      user: current_user,
      content: message,
    )
    broadcast({content: message})
  end

  # 他のユーザをChatRoomに招待する
  def invite(uid)
    # if user = User.find_by(id: uid)
    #   @room.users << user
    # end

    # current_userと紐づければ自分の友達のみ誘うことも可能
  end
  
  # Helpers
  def broadcast(add)
    payload = {
      room_id: @room.id,
      sender: current_user.name,
      participants: @room.users.collect(&:id)
    }
    self.class.broadcast_to(@room, payload.merge(add))
  end
end
