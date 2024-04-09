class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :statuses
  has_many :tasks, through: :statuses
  has_many :logs
  has_many :time_records


  def weekly_duration_sum
    checkins.where(checked_in_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
            .sum(&:duration_in_minutes) -
      checkouts.where(checked_out_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
               .sum(&:duration_in_minutes)
  end

  def statuses_submitted_last_week_count
    statuses.where(created_at: 1.week.ago..Time.now).count
  end

  def admin?
    role == "admin"
  end

  def checkin_time
    self.checkin_at
  end

  # Method to check if the user has checked in today
  def has_checked_in_today?
    time_records.exists?(check_in_at: true, created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  # Method to check if the user has checked out today
  def has_checked_out_today?
    time_records.exists?(check_out_at: true, created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end
end
