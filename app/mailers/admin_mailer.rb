class AdminMailer < ApplicationMailer
  def check_in_email(user)
    @user = user
    mail(to: 'meetsolanki140@gmail.com', subject: "Employee just Checked In Now!")
  end

  def check_out_email(user)
    @user = user
    mail(to: 'meetsolanki140@gmail.com', subject: "Employee just Checked Out Now!")
  end
end
