class Employee < ApplicationRecord
  has_many :status
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

end
