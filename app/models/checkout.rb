class Checkout < ApplicationRecord
  belongs_to :user

  def calculate_and_save_duration
    update(duration: (checked_out_at - user.checkouts.last.checked_out_at).to_i / 60)
  end
end
