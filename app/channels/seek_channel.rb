class SeekChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_player_#{current_user.id}"
    Seek.create(current_user.id)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
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
  def self.start(user_id1, user_id2)

    # ここで対戦用のChannelを保存、Channel名をそれぞれのプレイヤーに通知する
    room = Room.create(name: "room_#{user_id1}_#{user_id2}")

    ActionCable.server.broadcast "game_player_#{user_id1}", { action: "battle_start", room_id: "#{room.id}" }
    ActionCable.server.broadcast "game_player_#{user_id2}", { action: "battle_start", room_id: "#{room.id}" }
  end
end