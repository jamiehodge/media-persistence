require "forwardable"
require_relative "../fs"

module Media
  module Persistence
    module Models
      module Storable

        def storable(&block)
          class << self
            attr_accessor :storage
          end

          self.storage = FS.create(ENV["FS_PATH"], &block)

          include InstanceMethods
        end

        module InstanceMethods
          extend Forwardable

          def file
            @file ||= storage[file_id]
          end

          def file_id
            [id, extension].join
          end

          def type
            IO.popen(['file', '--brief', '--mime-type', path.to_s], in: :close, err: :close).read.chomp
          end

          def_delegators :file, :path, :size

          def after_destroy
            super
            storage.delete(file_id)
          end

          def after_save
            super
            return if File.identical?(storage[file_id], file)
            storage[file_id] = file
          end

          private

          def extension
            ::File.extname(name)
          end

          def storage
            self.class.storage[self.class.table_name]
          end
        end
      end
    end
  end
end
