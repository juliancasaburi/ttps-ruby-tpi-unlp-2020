module RN
  module Helpers
    class BookHelper
      require 'pathname'

      BASE_DIRECTORY = ENV['RN_DIRECTORY']
      EXTENSION = ENV['RN_NOTE_EXTENSION']

      def self.index
        Pathname(BASE_DIRECTORY).children.select(&:directory?).sort
      end

      def self.create(book)
        PersistenceLayer::PersistenceLayer.create_directory(BASE_DIRECTORY, book.name)
      rescue Errno::EEXIST
        raise Exceptions::BookAlreadyExistsException, book.name
      end

      def self.rename(old_name, new_name)
        if File.directory?(DirectoryHelper.book_route(BASE_DIRECTORY, new_name))
          raise Exceptions::BookAlreadyExistsException, new_name
        end

        begin
          PersistenceLayer::PersistenceLayer.move_directory(BASE_DIRECTORY, old_name, new_name)
        rescue Errno::ENOENT
          raise Exceptions::BookNotFoundException, old_name
        end
      end

      def self.delete_book(book_name)
        PersistenceLayer::PersistenceLayer.delete_directory(BASE_DIRECTORY, book_name)
      rescue Errno::ENOENT
        raise Exceptions::BookNotFoundException, book_name
      end

      def self.delete_global_notes
        File.delete(*Dir.glob("#{BASE_DIRECTORY}/*#{EXTENSION}"))
      end
    end
  end
end
