require "logger"
require "sequel"

module Media
  module Persistence
    Sequel.extension :blank, :pg_array_ops

    DB = Sequel.connect(ENV["DATABASE_URL"]).tap do |db|
      db.extension :null_dataset, :pg_array, :pg_streaming
      db.loggers << Logger if ENV["DEBUG"]
      db.stream_all_queries = true
    end
  end
end
