module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.name
    end

    protected
      # ログイン(セッション確率)時にしかsocket通信を行わない
      def find_verified_user
        # SPA×RailsAPIの場合はcookies.signed[:user_id]かも？
        if verified_user = User.find_by(id: request.session[:user_id])
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
