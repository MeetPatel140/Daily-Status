class AdminMailer < ApplicationMailer
  @admin_email = 'meetsolanki140@gmail.com'

  def check_in_email_admin(user)
    @user = user
    mail(to: @admin_email, subject: "#{@user.name} just Checked In Now!")
  end

  def check_in_email_user(user)
    @user = user
    mail(to: @user.email, subject: "You just Checked In Now!")
  end

  def check_out_email_admin(user)
    @user = user
    mail(to: @admin_email, subject: "#{@user.name} just Checked Out Now!")
  end

  def check_out_email_user(user)
    @user = user
    mail(to: @user.email, subject: "You just Checked Out Now!")
  end

  def new_status_email_admin(user, status)
    @user = user
    @status = status
    mail(to: @admin_email, subject: "#{@user.name} just Added New Status Now!")
  end

  def mark_as_resolved_email_admin(user, status)
    @user = user
    @status = status
    mail(to: @admin_email, subject: "#{@user.name} just Marked Status as Resolved Now!")
  end

  def mark_as_completed_email_user(user, status)
    @user = user
    @status = status
    mail(to: @user.email, subject: "You just Marked Status as Completed Now!")
  end
end
