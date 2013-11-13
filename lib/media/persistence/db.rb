require "sequel"

module Media
  module Persistence
    DB = Sequel.connect(ENV["DATABASE_URL"]).tap do |db|
      db.extension :pg_streaming
      db.stream_all_queries = true
    end
  end
end
