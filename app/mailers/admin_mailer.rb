class AdminMailer < ApplicationMailer
  def check_in_email(user)
    @user = user
    mail(to: 'meetsolanki140@gmail.com', subject: "Employee just Checked In Now!")
  end

  def check_out_email(user)
    @user = user
    mail(to: 'meetsolanki140@gmail.com', subject: "Employee just Checked Out Now!")
  end

  def new_status_email(user, status)
    @user = user
    @status = status
    mail(to: 'meetsolanki140@gmail.com', subject: "Employee just Added New Status Now!")
  end
end
