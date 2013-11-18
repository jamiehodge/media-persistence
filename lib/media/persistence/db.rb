require "logger"
require "sequel"

module Media
  module Persistence
    Sequel.extension :blank, :pg_array_ops

    DB = Sequel.connect(ENV["DATABASE_URL"]).tap do |db|
      db.extension :null_dataset, :pg_array, :pg_streaming
      db.loggers << Logger.new(STDOUT) if ENV["DEBUG"]
      db.stream_all_queries = true
    end

    Sequel::Postgres::PGArray.register "citext",
      oid: DB[:pg_type].where(typname: "_citext").get(:oid)

    DB.reset_conversion_procs
  end
end
