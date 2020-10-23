class Room < ApplicationRecord
    has_many :messages, foreign_key: :room_id, dependent: :destroy
    has_many :user_rooms
    has_many :users, through: :user_rooms
end
