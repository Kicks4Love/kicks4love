class Subsriber < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: Devise::email_regexp, message: "Please enter valid email address"}
end