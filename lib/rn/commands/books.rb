module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          if name.strip.empty?
            puts 'Debe ingresar un nombre de cuaderno no vacío'
          else
            book = Models::Book.new(name)
            Helpers::BookHelper.create(book)
            puts "El cuaderno #{book.name} fue creado exitosamente."
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          if !name.nil? && !name.strip.empty?
            Helpers::BookHelper.delete_book(name)
            puts "El cuaderno con título #{name} fue eliminado exitosamente."
          elsif global
            Helpers::BookHelper.delete_global_notes
            puts "El cuaderno #{ENV['RN_GLOBAL_BOOK_NAME']} fue vaciado exitosamente."
          else
            puts 'Debe ingresar un nombre de cuaderno no vacío'
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          dirs = Helpers::BookHelper.index
          if dirs.empty?
            puts 'No existe ningún cuaderno'
          else
            puts 'Listado de Cuadernos'
            dirs.each { |d| puts File.basename d }
          end
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          if old_name.strip.empty? || new_name.strip.empty?
            puts 'Debe ingresar un nombre de cuaderno no vacío'
          else
            book = Models::Book.new(new_name)
            Helpers::BookHelper.rename(old_name, book.name)
            puts "El cuaderno con nombre #{old_name} fue renombrado como #{book.name}"
          end
        end
      end
    end
  end
end
