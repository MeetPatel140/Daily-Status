class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :statuses
  has_many :tasks, through: :statuses
  has_many :checkouts, class_name: 'Checkout'
  has_many :logs
  has_many :checkins


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

  def has_checked_out_today?
    checkouts.exists?(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end
end
