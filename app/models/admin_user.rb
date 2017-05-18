class AdminUser < ApplicationRecord

  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
  validate :not_adding_root_user

  scope :non_root_users, -> {where("email NOT LIKE 'root%'")}

  def root_user?
  	return self.email.start_with?('root')
  end

  def self.root_user
  	return where("email LIKE 'root%'").first
  end

  protected

  def not_adding_root_user
    is_root_user = AdminUser.root_user.id == id
  	errors.add(:email, 'cannot start with \'root\'') if !is_root_user && email.downcase.start_with?('root')
  end

end