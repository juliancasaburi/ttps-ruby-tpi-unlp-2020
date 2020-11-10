module RN
  module Exceptions
    autoload :BookNotFoundException, 'rn/exceptions/book_not_found_exception'
    autoload :NoteNotFoundException, 'rn/exceptions/note_not_found_exception'
    autoload :NoteAlreadyExistsException, 'rn/exceptions/note_already_exists_exception'
    autoload :BookAlreadyExistsException, 'rn/exceptions/book_already_exists_exception'
  end
end
