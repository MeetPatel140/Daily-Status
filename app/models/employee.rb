class Employee < ApplicationRecord
  has_many :statuses
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

end
