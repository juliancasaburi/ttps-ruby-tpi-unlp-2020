module RN
  module Exceptions
    class NoteAlreadyExistsException < StandardError
      def initialize(note_title, book_name, msg = "[ERROR] Ya existe una nota con título '#{note_title}' en el cuaderno '#{book_name}'")
        super(msg)
      end
    end
  end
end
