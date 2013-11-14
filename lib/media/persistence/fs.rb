module Media
  module Persistence
    class FS

      attr_reader :path, :resolver

      def initialize(path, &block)
        @path  = Pathname(path).expand_path
        @resolver = block ||
          lambda {|path, id| path + id }
      end

      def self.create(path, &block)
        new(path, &block).make
      end

      def [](id)
        Directory.create(self, id)
      end

      def make
        path.mkpath
        self
      end

      def resolve(path, id)
        Pathname(resolver.call(path, id.to_s))
      end

      private

      class Directory

        attr_accessor :context, :id

        def initialize(context, id)
          @context = context
          @id = id
        end

        def self.create(context, id)
          new(context, id).make
        end

        def [](id)
          return File.new(file_path(id)) if file_path(id).exist?
          File.new(File::NULL)
        end

        def []=(id, io)
          io.rewind
          file_path(id).dirname.mkpath

          file_path(id).open("w") do |file|
            file << io.read(4096) until io.eof?
          end
        end

        def delete(id)
          path.unlink if path.exist?
        end

        def file_path(id)
          context.resolve(path, id)
        end

        def make
          path.mkpath
          self
        end

        def path
          context.path + id.to_s
        end
      end
    end
  end
end
