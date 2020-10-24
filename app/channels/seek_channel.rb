class SeekChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_player_#{current_user.id}"
    # Seek.create(current_user.id) 実際は待機画面についてすぐだからこっち　ーーーーーin
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Seek.remove(current_user.id)
  end

  def connect
    @seek = Seek.create(current_user.id) # ーーーーーーーーーーout
  end
end


class Seek
  def self.create(user_id)
    if opponent = REDIS.spop("seeks")
      # ここでマッチング成立ゲーム開始
      Rails.logger.debug "マッチング成功: user_id: #{user_id} / opponent_id: #{opponent}"
      Game.start(user_id, opponent)
    else
      REDIS.sadd("seeks", user_id)
    end
  end

  def self.remove(user_id)
    REDIS.srem("seeks", user_id)
  end

  def self.clear_all
    REDIS.del("seeks")
  end
end

class Game
  def self.start(uid1, uid2)

    # ここで対戦用のChannelを保存、Channel名をそれぞれのプレイヤーに通知する
    room = Room.create(name: "room_#{uid1}_#{uid2}", user_ids: [uid1, uid2])

    ActionCable.server.broadcast "game_player_#{uid1}", { action: "created the room", room_id: "#{room.id}" }
    ActionCable.server.broadcast "game_player_#{uid2}", { action: "created the room", room_id: "#{room.id}" }

    # ①user1 -> server　②server -> user2　③user2 -> server　②server -> user1  以後①~④をループ
    # のようなモデルを確立したい場合、上でbroadcastするものをroom.id(共通)ではなく別々の値をつける ※GameChannelとする
    # このようにすれば、　GameChannelA - Game - GameChannelB のような構図が作れるため
    # それぞれのUserからの送信はGameChannelで受け、Game内のロジックを経てもう一方のGameChannelに返すことが出来る。
    # ただ、こうするには Game-GameChannelの紐付けが必要。
    # <案1> GameChannel(独立したストリーム)と別に共通のストリームを持ったGameチャンネルを作る。
    # GameChannelAから受ける
  end
end