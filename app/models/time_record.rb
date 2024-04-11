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

  def self.check_in(user)
    create(user_id: user.id, check_in_at: Time.zone.now)
  end

  def self.check_out(user)
    record = where(user_id: user.id)
             .where(check_out_at: nil)
             .last
    record.update(check_out_at: Time.zone.now) if record
  end

  def self.monthly_attendance(user)
    start_of_month = Time.zone.now.beginning_of_month
    end_of_month = Time.zone.now.end_of_month

    attendance = {}
    (start_of_month..end_of_month).each do |date|
      attendance[date.day] = has_checked_in_on_day?(user, date) && has_checked_out_on_day?(user, date) ? '✅' : '❌'
    end
    attendance
  end

  private

  def self.has_checked_in_on_day?(user, date)
    where(user_id: user.id)
      .where('check_in_at >= ?', date.beginning_of_day)
      .where('check_in_at <= ?', date.end_of_day)
      .exists?
  end

  def self.has_checked_out_on_day?(user, date)
    where(user_id: user.id)
      .where('check_out_at >= ?', date.beginning_of_day)
      .where('check_out_at <= ?', date.end_of_day)
      .exists?
  end
end
