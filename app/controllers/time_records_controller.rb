class TimeRecordsController < ApplicationController

  def index
    year = params[:year].to_i
    month = params[:month].to_i

    start_date = Date.new(year, month, 1).beginning_of_day
    end_date = start_date.end_of_month

    time_records = current_user.time_records.where(check_in_at: start_date..end_date)

    render json: { timeRecords: time_records }
  end

  def check_in
    if current_user.has_checked_in_today?
      redirect_to root_path, alert: 'You have already checked in today.'
    else
      @check_in_record = current_user.time_records.create(check_in_at: Time.current)
      AdminMailer.check_in_email_user(current_user).deliver_now
      AdminMailer.check_in_email_admin(current_user).deliver_now
      Log.create(user_id: current_user.id, timestamp: Time.now, action: 'Checked In')
      redirect_to root_path, notice: 'Check-in successful!'
    end
  end

  def check_out
    check_in_record = current_user.time_records.last
    if check_in_record.nil?
      redirect_to root_path, alert: 'You have not Checked-In yet.'
    elsif current_user.has_checked_out_today? || check_in_record.check_out_at.present?
      redirect_to root_path, alert: 'You have already Checked-Out today.'
    else
      check_in_record.update(check_out_at: Time.current)
      AdminMailer.check_out_email_user(current_user).deliver_now
      AdminMailer.check_out_email_admin(current_user).deliver_now
      Log.create(user_id: current_user.id, timestamp: Time.now, action: 'Checked Out')
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

  # Action to fetch and return weekly employee count data
  def weekly_employee_count
    # Get the start and end date of the current week
    start_of_week = Date.current.beginning_of_week
    end_of_week = Date.current.end_of_week

    # Initialize an empty array to store the weekly counts
    weekly_counts = []

    # Iterate over each day of the current week
    (start_of_week..end_of_week).each do |date|
      # Count the number of employees who checked in on the current day
      count = TimeRecord.where("DATE(check_in_at) = ?", date)
                        .count
      # Add the count to the weekly_counts array
      weekly_counts << { date: date.strftime("%A"), count: count }
    end

    # Respond with JSON containing the weekly counts
    render json: { weeklyCounts: weekly_counts }
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
    # Calculate the start and end dates of the current week
    start_date = Date.current.beginning_of_week
    end_date = Date.current.end_of_week

    # Retrieve time records for the current user within the current week's date range
    time_records = current_user.time_records.where(check_in_at: start_date.beginning_of_day..end_date.end_of_day)

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
