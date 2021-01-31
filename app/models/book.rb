class Book < ApplicationRecord
  belongs_to :user, inverse_of: 'books'
  has_many :notes, inverse_of: 'book', dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :user_id }
  validates_associated :user
end
