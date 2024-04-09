class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def create
    @checkout = current_user.checkouts.build(checkout_params)
    @checkout.calculate_and_save_duration

    # rest of the code
  end

  def process_checkouts
    # Calculate duration based on checked in time and current time
    checkin_time = current_user.checkins.last.checked_in_at
    checkout_time = Time.current
    duration = calculate_duration(checkin_time, checkout_time)

    # Create a new checkout record with the calculated duration
    checkout = current_user.checkouts.new(checked_out_at: checkout_time, duration: duration)

    if checkout.save
      # Log the checkout action and send email
      Log.create(user_id: current_user.id, timestamp: Time.now, action: 'check-out')
      AdminMailer.check_out_email(current_user).deliver_now

      redirect_to root_path, notice: 'Check-out successful!'
    else
      # Handle validation errors or other issues
      redirect_to root_path, alert: 'Check-out failed!'
    end
  end

  # Action to fetch the recorded duration
  def get_recorded_duration
    # Fetch the latest checkout associated with the current user
    latest_checkout = current_user.time_records.last
    if latest_checkout
      render json: { duration: latest_checkout.duration }
    else
      render json: { duration: '00:00:00' }
    end
  end

  private

  def checkout_params
    params.require(:checkout).permit(:duration) # Add :duration to the permitted parameters
  end

  # Method to calculate duration
  def calculate_duration(checkin_time, checkout_time)
    # Calculate duration in seconds
    duration_seconds = checkout_time - checkin_time

    # Convert duration to HH:MM:SS format
    hours = duration_seconds / 3600
    minutes = (duration_seconds % 3600) / 60
    seconds = duration_seconds % 60

    # Return formatted duration string
    format('%02d:%02d:%02d', hours, minutes, seconds)
  end
end
