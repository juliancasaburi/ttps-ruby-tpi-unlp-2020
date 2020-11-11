module RN
  module Helpers
    class NoteHelper
      BASE_DIRECTORY = ENV['RN_DIRECTORY']
      EXTENSION = ENV['RN_NOTE_EXTENSION']

      class << self
        # Levanta excepción si no existe el cuaderno
        def raise_if_book_doesnt_exist(directory, book_name)
          raise Exceptions::BookNotFoundException, book_name unless DirectoryHelper.directory_exists?(directory)

          true
        end

        # Levanta excepción si no existe la nota
        def raise_if_note_doesnt_exist(directory, note_title, book_name)
          unless File.file?(DirectoryHelper.note_route(directory, note_title, EXTENSION))
            raise Exceptions::NoteNotFoundException.new(note_title, book_name)
          end

          true
        end

        # Levanta excepción si existe la nota
        def raise_if_note_already_exists(directory, note_title, book_name)
          if File.file?(DirectoryHelper.note_route(directory, note_title, EXTENSION))
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
      end

      def self.index
        hash = {}
        # Se agregan al hash las notas del cuaderno global
        global_notes = index_global_book
        hash[ENV['RN_GLOBAL_BOOK_NAME']] = global_notes unless global_notes.empty?
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

      def self.index_global_book
        Dir.chdir(BASE_DIRECTORY)
        Dir.glob("*.#{EXTENSION}").sort.collect { |note| File.basename(note, ".#{EXTENSION}") }
      end

      def self.index_book(book_name)
        Dir.chdir(DirectoryHelper.book_route(BASE_DIRECTORY, book_name))
        Dir.glob("*.#{EXTENSION}").sort.collect { |note| File.basename(note, ".#{EXTENSION}") }
      rescue Errno::ENOENT
        raise Exceptions::BookNotFoundException, book_name
      end

      def self.save_using_editor(note)
        directory = DirectoryHelper.working_directory(BASE_DIRECTORY, note.book)
        NoteHelper.raise_if_book_doesnt_exist(directory, note.book)
        NoteHelper.raise_if_note_already_exists(directory, note.title, note.book)
        NoteHelper.open_and_wait(DirectoryHelper.note_route(directory, note.title, EXTENSION)) do
          puts "La nota con título #{note.title} fue creada exitosamente en el cuaderno #{note.book}"
          exit
        end
      end

      def self.save(note)
        PersistenceLayer::PersistenceLayer.save_file(DirectoryHelper.working_directory(BASE_DIRECTORY, note.book), DirectoryHelper.note_file_name(note.title, EXTENSION), note.content)
      end

      # Retorna una instancia de Note dado el nombre del cuaderno y el titulo de la nota
      def self.load(book_name, note_title)
        book_name ||= ENV['RN_GLOBAL_BOOK_NAME']
        directory = DirectoryHelper.working_directory(BASE_DIRECTORY, book_name)
        NoteHelper.raise_if_book_doesnt_exist(directory, book_name)
        begin
          f = PersistenceLayer::PersistenceLayer.load_file(directory, DirectoryHelper.note_file_name(note_title, EXTENSION))
          note = Models::Note.new(note_title, book_name, f.read)
          f.close
          note
        rescue Errno::ENOENT
          raise Exceptions::NoteNotFoundException.new(note_title, book_name)
        end
      end

      def self.edit(book_name, note_title)
        book_name ||= ENV['RN_GLOBAL_BOOK_NAME']
        directory = DirectoryHelper.working_directory(BASE_DIRECTORY, book_name)
        NoteHelper.raise_if_book_doesnt_exist(directory, book_name)
        NoteHelper.raise_if_note_doesnt_exist(directory, note_title, book_name)
        # Abre la nota en el editor por defecto
        NoteHelper.open_and_wait(DirectoryHelper.note_route(directory, note_title, EXTENSION)) do
          puts "La nota con título #{note_title}, del cuaderno #{book_name} fue editada exitosamente"
          exit
        end
      end

      def self.delete(book_name, note_title)
        book_name ||= ENV['RN_GLOBAL_BOOK_NAME']
        directory = DirectoryHelper.working_directory(BASE_DIRECTORY, book_name)
        begin
          PersistenceLayer::PersistenceLayer.delete_file(DirectoryHelper.note_route(directory, note_title, EXTENSION))
        rescue Errno::ENOENT
          raise Exceptions::NoteNotFoundException.new(note_title, book_name)
        end
      end

      def self.retitle(old_title, note)
        directory = DirectoryHelper.working_directory(BASE_DIRECTORY, note.book)
        NoteHelper.raise_if_note_already_exists(directory, note.title, note.book)
        FileUtils.mv(DirectoryHelper.note_route(directory, old_title, EXTENSION), DirectoryHelper.note_route(directory, note.title, EXTENSION))
      end
    end
  end
end
