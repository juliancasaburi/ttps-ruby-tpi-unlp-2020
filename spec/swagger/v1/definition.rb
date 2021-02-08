API_V1 = {
  swagger: '2.0',
  info: {
    title: 'API V1',
    version: 'v1'
  },
  basePath: '/api/v1',
  definitions: {
    book: BOOK_SCHEMA,
    books_collection: BOOKS_COLLECTION_SCHEMA,
    book_resource: BOOK_RESOURCE_SCHEMA,
    note: NOTE_SCHEMA,
    notes_collection: NOTES_COLLECTION_SCHEMA,
    note_resource: NOTE_RESOURCE_SCHEMA,
  }
}
