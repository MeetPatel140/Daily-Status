class NewStatusController < ApplicationController
  before_action :authenticate_user!

  def send_email
    @user = current_user
    AdminMailer.new_statuses_email(@user).deliver_now
    redirect_to status_path(@status)
  end
end
