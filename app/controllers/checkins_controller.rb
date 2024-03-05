class CheckinsController < ApplicationController
  def create
    @checkin = current_user.checkins.build(checkin_params)
    @checkin.calculate_and_save_duration

    # rest of the code
  end
end
