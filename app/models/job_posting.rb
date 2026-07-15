class JobPosting < ApplicationRecord
  belongs_to :company

  scope :remote, -> { where(remote_ok: true) }
  scope :salary_gte, ->(amount) { where(salary_min: amount..) }
  scope :tech, ->(keyword) { where("tech_stack LIKE ?", "%#{sanitize_sql_like(keyword)}%") }
end
