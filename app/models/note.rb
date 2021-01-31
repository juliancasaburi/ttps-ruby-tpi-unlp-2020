class Note < ApplicationRecord
  belongs_to :user, inverse_of: 'notes'
  belongs_to :book, inverse_of: 'notes'

  validates :title, presence: true, length: { maximum: 255 }, uniqueness: { scope: %i[user_id book_id] }
  validates :color, presence: true
  validates_associated :user, :book

  def to_pdf
    # Disable Prawn UTF-8 warning
    Prawn::Fonts::AFM.hide_m17n_warning = true
    Kramdown::Document.new(content || '').to_pdf
  end
end
