class RoomsController < ApplicationController
  def show
    if @room = current_user.rooms.find_by(id: params[:id])
      @messages = @room.messages.all
    else
      redirect_to root_path, notice: "Room(id: #{params[:id]})が見つかりません。"
    end
  end
end
