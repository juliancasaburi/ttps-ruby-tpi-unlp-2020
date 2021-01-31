class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :books, inverse_of: 'user', dependent: :destroy
  has_many :notes, inverse_of: 'user', dependent: :destroy

  def global_book
    books.find_by!(name: 'Global')
  end
end
