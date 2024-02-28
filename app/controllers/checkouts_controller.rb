class CheckoutsController < ApplicationController
  def process_checkouts
    AdminMailer.check_out_email(current_user).deliver_now
    redirect_to root_path, notice: 'Check-out successful!'
  end
end
