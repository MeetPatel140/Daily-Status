# app/models/time_record.rb
class TimeRecord < ApplicationRecord
  belongs_to :user

  def calculate_and_set_duration
    return unless check_in_at && check_out_at

    duration_seconds = (check_out_at - check_in_at).to_i
    update(duration_in_seconds: duration_seconds)
  end

  def self.has_checked_in_today?(user)
    where(user_id: user.id)
      .where('check_in_at >= ?', Time.zone.now.beginning_of_day)
      .where('check_in_at <= ?', Time.zone.now.end_of_day)
      .exists?
  end

  def self.has_checked_out_today?(user)
    where(user_id: user.id)
      .where('check_out_at >= ?', Time.zone.now.beginning_of_day)
      .where('check_out_at <= ?', Time.zone.now.end_of_day)
      .exists?
  end

end
