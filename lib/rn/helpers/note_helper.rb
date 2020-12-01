module RN
  module Helpers
    class NoteHelper
      GLOBAL_BOOK_NAME = ENV['RN_GLOBAL_BOOK_NAME']
      BASE_DIRECTORY = ENV['RN_DIRECTORY']
      EXTENSION = ENV['RN_NOTE_EXTENSION']

      class << self
        # Levanta excepción si no existe el cuaderno
        def raise_if_book_doesnt_exist(directory, book_name)
          unless book_name.eql?(GLOBAL_BOOK_NAME) || File.directory?(directory)
            raise Exceptions::BookNotFoundException, book_name
          end

          true
        end

        # Levanta excepción si no existe la nota
        def raise_if_note_doesnt_exist(directory, note_title, book_name)
          unless File.file?(RouteHelper.note_route(directory, note_title))
            raise Exceptions::NoteNotFoundException.new(note_title, book_name)
          end

          true
        end

        # Levanta excepción si existe la nota
        def raise_if_note_already_exists(directory, note_title, book_name)
          if File.file?(RouteHelper.note_route(directory, note_title))
            raise Exceptions::NoteAlreadyExistsException.new(note_title, book_name)
          end

          false
        end

        def open_and_wait(full_path)
          # Abre la nota en el editor por defecto
          editor = TTY::Editor.new(raise_on_failure: true)
          editor.open(full_path)
          # Espera a que el usuario finalice la edición y guarde la nota
          listener = Listen.to(File.dirname(full_path)) do # Gem guard/listen
            yield if block_given?
          end
          listener.start
          sleep
        end

        def do_with_book_notes(book_name)
          begin
            directory = working_directory(BASE_DIRECTORY, book_name)
            Dir.chdir(directory)
            notes = Dir.glob("*.#{EXTENSION}")
            yield notes if block_given?
          end
        rescue Errno::ENOENT
          raise Exceptions::BookNotFoundException, book_name
        end
      end

      def self.index
        hash = {}
        # Se agregan al hash las notas del cuaderno global
        global_notes = index_book(GLOBAL_BOOK_NAME)
        hash[GLOBAL_BOOK_NAME] = global_notes unless global_notes.empty?
        # Se agregan al hash las notas de los cuadernos creados por el usuario
        dirs = Pathname(BASE_DIRECTORY).children.select(&:directory?)
        dirs.each do |dir|
          Dir.chdir(dir)
          notes = Dir.glob("*.#{EXTENSION}").sort.collect { |note| File.basename(note, ".#{EXTENSION}") }
          # Si el libro está vacío (no contiene notas), no se agrega al hash
          hash[dir.basename.to_s] = notes.to_a unless notes.empty?
        end
        hash.sort
      end

      def self.index_book(book_name)
        NoteHelper.do_with_book_notes(book_name) { |notes| notes.sort.collect { |note| File.basename(note, ".#{EXTENSION}") } }
      end

      def self.save_using_editor(note)
        directory = working_directory(BASE_DIRECTORY, note.book)
        NoteHelper.raise_if_book_doesnt_exist(directory, note.book)
        NoteHelper.raise_if_note_already_exists(directory, note.title, note.book)
        NoteHelper.open_and_wait(RouteHelper.note_route(directory, note.title)) do
          puts "La nota con título #{note.title} fue creada exitosamente en el cuaderno #{note.book}"
          exit
        end
      end

      def self.save(note)
        PersistenceLayer::FilePersistenceLayer.save_file(working_directory(BASE_DIRECTORY, note.book), note_file_name(note.title), note.content)
      end

      # Retorna una instancia de Note dado el nombre del cuaderno y el titulo de la nota
      def self.load(book_name, note_title)
        book_name ||= GLOBAL_BOOK_NAME
        directory = working_directory(BASE_DIRECTORY, book_name)
        NoteHelper.raise_if_book_doesnt_exist(directory, book_name)
        begin
          note_file = PersistenceLayer::FilePersistenceLayer.load_file(directory, note_file_name(note_title))
          note = Models::Note.from_file(note_file, book_name)
          note_file.close
          note
        rescue Errno::ENOENT
          raise Exceptions::NoteNotFoundException.new(note_title, book_name)
        end
      end

      def self.edit(book_name, note_title)
        book_name ||= GLOBAL_BOOK_NAME
        directory = working_directory(BASE_DIRECTORY, book_name)
        NoteHelper.raise_if_book_doesnt_exist(directory, book_name)
        NoteHelper.raise_if_note_doesnt_exist(directory, note_title, book_name)
        # Abre la nota en el editor por defecto
        NoteHelper.open_and_wait(RouteHelper.note_route(directory, note_title)) do
          puts "La nota con título #{note_title}, del cuaderno #{book_name} fue editada exitosamente"
          exit
        end
      end

      def self.delete(book_name, note_title)
        book_name ||= GLOBAL_BOOK_NAME
        directory = working_directory(BASE_DIRECTORY, book_name)
        begin
          PersistenceLayer::FilePersistenceLayer.delete_file(RouteHelper.note_route(directory, note_title))
        rescue Errno::ENOENT
          raise Exceptions::NoteNotFoundException.new(note_title, book_name)
        end
      end

      def self.retitle(old_title, note)
        directory = working_directory(BASE_DIRECTORY, note.book)
        NoteHelper.raise_if_note_already_exists(directory, note.title, note.book)
        FileUtils.mv(RouteHelper.note_route(directory, old_title), RouteHelper.note_route(directory, note.title))
      end

      def self.note_file_name(note_title)
        "#{note_title}.#{EXTENSION}"
      end

      # Retorna el path del directorio dependiendo del nombre del cuaderno
      def self.working_directory(base_directory, book_name)
        if book_name.eql?(GLOBAL_BOOK_NAME)
          base_directory
        else
          RouteHelper.book_route(base_directory, book_name)
        end
      end
    end
  end
end
