class User < ApplicationRecord
    has_secure_password
    has_many :messages

    has_many :user_rooms, dependent: :destroy
    has_many :rooms, through: :user_rooms, foreign_key: :user_id
end
