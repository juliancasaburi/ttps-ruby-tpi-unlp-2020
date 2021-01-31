class Api::V1::BookSerializer < ActiveModel::Serializer
  type :book

  attributes(
    :name,
    :user_id,
    :created_at,
    :updated_at,
    :note_count
  )

  def created_at
    object.created_at.strftime('%d/%m/%Y %I:%M:%S')
  end

  def updated_at
    object.created_at.strftime('%d/%m/%Y %I:%M:%S')
  end

  def note_count
    object.notes.size
  end
end
