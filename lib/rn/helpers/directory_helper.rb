module RN
  module Helpers
    class DirectoryHelper
      def self.directory_exists?(directory)
        File.directory?(directory)
      end

      def self.working_directory(base_directory, book_name)
        if book_name.eql?(ENV['RN_GLOBAL_BOOK_NAME'])
          base_directory
        else
          book_route(base_directory, book_name)
        end
      end

      def self.book_route(base_directory, book_name)
        "#{base_directory}/#{book_name}"
      end

      def self.note_file_name(note_title, extension)
        "#{note_title}.#{extension}"
      end

      def self.note_route(book_directory, note_title, extension)
        "#{book_directory}/#{note_file_name(note_title, extension)}"
      end
    end
  end
end
