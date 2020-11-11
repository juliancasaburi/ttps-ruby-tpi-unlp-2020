module RN
  module Helpers
    class RouteHelper
      def self.book_route(base_directory, book_name)
        "#{base_directory}/#{book_name}"
      end

      def self.note_route(book_directory, note_title)
        "#{book_directory}/#{NoteHelper.note_file_name(note_title)}"
      end
    end
  end
end
