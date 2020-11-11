module RN
  module PersistenceLayer
    class FilePersistenceLayer
      def self.load_file(directory, file_name)
        File.open("#{directory}/#{file_name}", 'r')
      end

      def self.save_file(directory, file_name, content)
        File.open("#{directory}/#{file_name}", 'w') { |file| file.puts content }
      end

      def self.create_directory(path, directory_name)
        Dir.mkdir("#{path}/#{directory_name}")
      end

      def self.rename_directory(path, old_directory_name, new_directory_name)
        FileUtils.mv("#{path}/#{old_directory_name}", "#{path}/#{new_directory_name}")
      end

      def self.delete_directory(path, directory_name)
        FileUtils.remove_dir("#{path}/#{directory_name}")
      end

      def self.delete_file(directory)
        File.delete(directory)
      end
    end
  end
end
