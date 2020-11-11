module RN
  module Models
    class Note
      attr_accessor :book, :content
      attr_reader :title

      def initialize(title, book, content)
        @title = sanitize_title(title)
        @book = book || ENV['RN_GLOBAL_BOOK_NAME']
        @content = content
      end

      def to_s
        puts "Cuaderno: #{book}"
        puts "Titulo: #{title}"
        puts "Contenido: #{content}"
      end

      def title=(title)
        @title = sanitize_title(title)
      end

      def sanitize_title(title)
        title.gsub(/[^0-9A-Za-z.\-]/, '_').downcase
      end
    end
  end
end
