BOOK_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: '1' },
    type: { type: :string, example: 'book' },
    attributes: {
      type: :object,
      properties: {
        name: { type: :string, example: 'Some name' },
        user_id: { type: :integer, example: 666, 'x-nullable': true },
        created_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
        updated_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true }
      },
      required: [
        :name
      ]
    }
  },
  required: %i[
    id
    type
    attributes
  ]
}

BOOKS_COLLECTION_SCHEMA = {
  type: 'object',
  properties: {
    data: {
      type: 'array',
      items: { '$ref' => '#/definitions/book' }
    }
  },
  required: [
    :data
  ]
}

BOOK_RESOURCE_SCHEMA = {
  type: 'object',
  properties: {
    data: { '$ref' => '#/definitions/book' }
  },
  required: [
    :data
  ]
}
