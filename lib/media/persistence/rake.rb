require "rake"

namespace :db do

  task :environment do
    require_relative "db"
  end

  desc "create"
  task :create do
    `createdb -E UTF8 $DATABASE_URL`
  end

  desc "drop"
  task :drop do
    `dropdb $DATABASE_URL`
  end

  desc "reset"
  task reset: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:setup"].invoke
  end

  desc "seed"
  task seed: :environment do
    require File.expand_path("db/seed")
  end

  desc "setup"
  task setup: :environment do
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end

  namespace :migrate do

    desc "environment"
    task environment: "db:environment" do
      Sequel.extension :migration
      require_relative "migration"
      @path = File.expand_path("db/migrations")
    end

    desc "auto"
    task auto: :environment do
      Rake::Task["db:migrate:down"].invoke
      Rake::Task["db:migrate:up"].invoke
    end

    desc "down"
    task down: :environment do
      Sequel::Migrator.apply(Media::Persistence::DB, @path, 0)
    end

    desc "up"
    task up: :environment do
      Sequel::Migrator.apply(Media::Persistence::DB, @path)
    end
  end

  task migrate: "db:migrate:up"
end
