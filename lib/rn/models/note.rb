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

      def self.from_file(note_file, book = nil)
        title = File.basename(Pathname.new(note_file.path), ".#{ENV['RN_NOTE_EXTENSION']}")
        content = note_file.read
        new(title, book, content)
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

      def to_pdf
        # Disable Prawn UTF-8 warning
        Prawn::Fonts::AFM.hide_m17n_warning = true
        Kramdown::Document.new(content).to_pdf
      end
    end
  end
end
