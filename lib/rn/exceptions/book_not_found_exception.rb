module RN
  module Exceptions
    class BookNotFoundException < StandardError
      def initialize(book_name, msg = "[ERROR] El cuaderno con nombre '#{book_name}' no fue encontrado")
        super(msg)
      end
    end
  end
end
