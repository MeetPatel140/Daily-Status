class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :statuses

  enum role: [:employee, :admin]

  def set_default_role
    self.role ||= :employee
  end

  def admin?
    role == "admin"
  end

  def employee?
    role == "employee"
  end

end
