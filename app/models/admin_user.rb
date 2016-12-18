class AdminUser < ApplicationRecord

  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  scope :non_root_users, -> {where("email NOT LIKE 'root%'")}

  def root_user?
  	return self.email.start_with?('root')
  end

  def self.root_user
  	return where("email LIKE 'root%'").first
  end

end
