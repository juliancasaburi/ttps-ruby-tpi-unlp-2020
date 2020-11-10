module RN
  module Exceptions
    class NoteNotFoundException < StandardError
      def initialize(note_title, book_name, msg = "[ERROR] La nota con título '#{note_title}' no fue encontrada en el cuaderno '#{book_name}'")
        super(msg)
      end
    end
  end
end
