class Borrower < ActiveRecord::Base

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  has_secure_password

  has_many :transactions
  has_many :lenders, through: :transactions

  validates :first_name, :last_name, :purpose, :description, :money, presence: true,  on: :create
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX },  on: :create
  validates :password, length: { minimum: 4 },  on: :create
  validates :password_confirmation, presence: true ,  on: :create
end
