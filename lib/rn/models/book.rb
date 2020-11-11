module RN
  module Models
    class Book
      attr_reader :name

      def initialize(name)
        @name = sanitize_name(name)
      end

      def to_s
        puts "Nombre: #{name}"
      end

      def name=(name)
        @name = sanitize_name(name)
      end

      def sanitize_name(name)
        name.gsub(/[^0-9A-Za-z.\-]/, '_').downcase
      end
    end
  end
end
