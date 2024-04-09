class TimeRecordsController < ApplicationController

  def check_in
    if current_user.has_checked_in_today?
      redirect_to root_path, alert: 'You have already checked in today.'
    else
      @check_in_record = current_user.time_records.create(check_in_at: Time.current)
      redirect_to root_path, notice: 'Check-in successful!'
    end
  end

  def check_out
    check_in_record = current_user.time_records.last
    if current_user.has_checked_out_today? || check_in_record.nil? || check_in_record.check_out_at.present?
      redirect_to root_path, alert: 'You have already checked out today or have not checked in yet.'
    else
      check_in_record.update(check_out_at: Time.current)
      check_in_record.calculate_and_set_duration
      redirect_to root_path, notice: 'Check-out successful!'
    end
  end

  def get_checkin_time
    checkin_record = current_user.time_records.last
    if checkin_record
      render json: { checkin_time: checkin_record.check_in_at }
    else
      render json: { checkin_time: nil }
    end
  end

  def get_recorded_duration
    latest_record = current_user.time_records.last
    if latest_record
      render json: { duration: latest_record.duration_in_seconds }
    end
  end

  # Check if the user has checked in today
  def has_checked_in_today?
    current_user.time_records.exists?(check_in_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  # Check if the user has checked out today
  def has_checked_out_today?
    current_user.time_records.exists?(check_out_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  def weekly_durations
    # Calculate the start and end dates of last week
    start_date = Date.current.beginning_of_week
    end_date = Date.current.end_of_week

    # Retrieve time records for the current user within the last week's date range
    time_records = current_user.time_records.where(created_at: start_date.beginning_of_day..end_date.end_of_day)

    # Initialize a hash to store weekly durations for each day of the week
    weekly_durations = {
      "Monday" => 0,
      "Tuesday" => 0,
      "Wednesday" => 0,
      "Thursday" => 0,
      "Friday" => 0,
      "Saturday" => 0,
      "Sunday" => 0
    }

    # Calculate the total duration for each day of the week
    time_records.each do |record|
      day_of_week = record.check_in_at.strftime("%A")
      weekly_durations[day_of_week] += record.duration_in_seconds
    end

    # Convert duration from seconds to hours
    weekly_durations.each { |day, duration| weekly_durations[day] = duration / 3600.0 }

    render json: { durations: weekly_durations.map { |day, duration| { date: day, duration: duration } } }
  end

end
