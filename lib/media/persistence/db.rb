require "logger"
require "sequel"

module Media
  module Persistence
    DB = Sequel.connect(ENV["DATABASE_URL"]).tap do |db|
      db.extension :null_dataset, :pg_streaming
      db.loggers << Logger if ENV["DEBUG"]
      db.stream_all_queries = true
    end
  end
end
