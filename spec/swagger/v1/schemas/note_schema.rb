NOTE_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string, example: '1' },
    type: { type: :string, example: 'note' },
    attributes: {
      type: :object,
      properties: {
        title: { type: :string, example: 'Some title', 'x-nullable': true },
        content: { type: :string, example: 'Some content', 'x-nullable': true },
        book_id: { type: :integer, example: 666, 'x-nullable': true },
        created_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true },
        updated_at: { type: :string, example: '1984-06-04 09:00', 'x-nullable': true }
      },
      required: []
    }
  },
  required: %i[
    id
    type
    attributes
  ]
}

NOTES_COLLECTION_SCHEMA = {
  type: 'object',
  properties: {
    data: {
      type: 'array',
      items: { '$ref' => '#/definitions/note' }
    }
  },
  required: [
    :data
  ]
}

NOTE_RESOURCE_SCHEMA = {
  type: 'object',
  properties: {
    data: { '$ref' => '#/definitions/note' }
  },
  required: [
    :data
  ]
}
