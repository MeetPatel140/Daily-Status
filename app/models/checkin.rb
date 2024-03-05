class Checkin < ApplicationRecord
  belongs_to :user

  def calculate_and_save_duration
    update(duration: (checked_out_at - user.checkins.last.duration).to_i / 60)
  end
end
