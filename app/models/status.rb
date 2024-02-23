class Status < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_one_attached :screenshot

  validates :date, presence: true
  validates :daily_report, presence: true
  validates :github_pr_link, presence: true

  accepts_nested_attributes_for :tasks, allow_destroy: true
end
