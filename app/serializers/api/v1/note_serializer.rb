class Api::V1::NoteSerializer < ActiveModel::Serializer
  type :note

  attributes(
    :title,
    :content,
    :color,
    :created_at,
    :updated_at,
    :book
  )

  def created_at
    object.created_at.strftime('%d/%m/%Y %I:%M:%S')
  end

  def updated_at
    object.created_at.strftime('%d/%m/%Y %I:%M:%S')
  end

  def book
    ActiveModel::SerializableResource.new(object.book)
  end
end
