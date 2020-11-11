module RN
  module Exceptions
    class BookAlreadyExistsException < StandardError
      def initialize(book_name, msg = "[ERROR] Ya existe el cuaderno con nombre '#{book_name}'")
        super(msg)
      end
    end
  end
end
