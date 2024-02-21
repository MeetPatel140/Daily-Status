class Status < ApplicationRecord
  belongs_to :employee
  has_many :tasks, dependent: :destroy
  has_one_attached :screenshot

  validates :check_in, presence: true
  validates :check_out, presence: true
  validates :date, presence: true
  validates :daily_report, presence: true
  validates :github_pr_link, presence: true

  accepts_nested_attributes_for :tasks, allow_destroy: true
end
