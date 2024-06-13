class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  validates :email, presence: true
  validates :name, presence: true
  has_many :borrows, dependent: :destroy, foreign_key: :member_id

  enum role: %i[librarian member]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
