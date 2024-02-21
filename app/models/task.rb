class Task < ApplicationRecord
  belongs_to :status
  has_one_attached :screenshot

  validates :title, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

end
