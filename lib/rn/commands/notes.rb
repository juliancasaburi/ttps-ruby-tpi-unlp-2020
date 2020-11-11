module RN
  module Commands
    module Notes
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'
        option :content, type: :string, desc: 'Content of the note'

        example [
          'todo                                               # Creates a note titled "todo" in the global book (Opens default editor)',
          'todo --content "a content"                         # Creates a note titled "todo" in the global book, with content "a content"',
          '"New note" --book "My book"                        # Creates a note titled "New note" in the book "My book" (Opens default editor)',
          '"New note" --book "My book" --content "a content"  # Creates a note titled "New note" in the book "My book", with content "a content"',
          'thoughts --book Memoires --content "a content"     # Creates a note titled "thoughts" in the book "Memoires", with content "a content"'
        ]

        def call(title:, **options)
          if title.strip.empty?
            puts 'Debe ingresar un titulo de nota no vacío'
          else
            book = options[:book]
            content = options[:content]
            note = Models::Note.new(title, book, content)
            # Si se provee --content, no se abre el editor visual
            if !content.nil?
              Helpers::NoteHelper.save(note)
              puts "La nota con título #{title} fue creada exitosamente en el cuaderno #{note.book}"
            else
              Helpers::NoteHelper.save_using_editor(note)
            end
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          if title.strip.empty?
            puts 'Debe ingresar un titulo de nota no vacío'
          else
            book = options[:book]
            Helpers::NoteHelper.delete(book, title)
            puts "La nota #{title} del cuaderno '#{book || ENV['RN_GLOBAL_BOOK_NAME']}' fue eliminada exitosamente."
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content of a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book (Opens default editor)',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book" (Opens default editor)',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires" (Opens default editor)'
        ]

        def call(title:, **options)
          if title.strip.empty?
            puts 'Debe ingresar un titulo de nota no vacío'
          else
            book = options[:book]
            Helpers::NoteHelper.edit(book, title)
          end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          if old_title.strip.empty? || new_title.strip.empty?
            puts 'Debe ingresar un titulo de nota no vacío'
          else
            book = options[:book]
            note = Helpers::NoteHelper.load(book, old_title)
            note.title = new_title
            Helpers::NoteHelper.retitle(old_title, note)
            puts "La nota #{old_title} del cuaderno '#{book || ENV['RN_GLOBAL_BOOK_NAME']}' fue renombrada como #{note.title}"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          if global
            note_titles = Helpers::NoteHelper.index_global_book
            List.list_notes_from_book(ENV['RN_GLOBAL_BOOK_NAME'], note_titles)
          elsif !book.nil?
            note_titles = Helpers::NoteHelper.index_book(book)
            List.list_notes_from_book(book, note_titles)
          else
            note_titles = Helpers::NoteHelper.index
            if note_titles.empty?
              puts 'No existe ninguna nota.'
            else
              note_titles.each do |key, value|
                List.list_notes_from_book(key, value)
                puts ''
              end
            end
          end
        end

        class << self
          def list_notes_from_book(book_name, note_titles)
            if note_titles.empty?
              puts "El cuaderno '#{book_name}' está vacío."
            else
              puts "Notas del cuaderno '#{book_name}'"
              puts note_titles
            end
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          if title.strip.empty?
            puts 'Debe ingresar un titulo de nota no vacío'
          else
            book = options[:book]
            note = Helpers::NoteHelper.load(book, title)
            puts note.to_s
          end
        end
      end
    end
  end
end
