class CheckinsController < ApplicationController
  def create
    @checkin = current_user.checkins.build(checkin_params)
    @checkin.calculate_and_save_duration

    # rest of the code
  end

  def get_checkin_time
    # Find the current user's latest check-in record
    checkin = current_user.time_records.last

    # Check if a check-in record exists
    if checkin
      render json: { checkin_time: time_record.check_in_at }
    else
      # If no check-in record exists, return a 404 status
      render json: { error: 'No check-in record found' }, status: :not_found
    end
  end

  def process_checkins
    checkin = current_user.time_records.new(checked_in_at: Time.current)
    if checkin.save
      Log.create(user_id: @current_user.id, timestamp: Time.now, action: 'check-in')
      AdminMailer.check_in_email(current_user).deliver_now
      redirect_to root_path, notice: 'Check-in successful!'
    else
      # Handle validation errors or other issues
      redirect_to root_path, alert: 'Check-in failed!'
    end
  end
end
