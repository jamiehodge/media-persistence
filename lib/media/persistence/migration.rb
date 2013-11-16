require "sequel"

class Sequel::Schema::CreateTableGenerator

  def uuid_foreign_key(name, table, options = {})
    foreign_key name, table, { index: true, null: false, type: :uuid }.merge(options)
  end

  def uuid_primary_key
    uuid :id, default: Sequel.function(:uuid_generate_v4), primary_key: true
  end

  def timestamps
    timestamptz :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
    timestamptz :updated_at, default: Sequel::CURRENT_TIMESTAMP, null: false
  end

  def lock_version
    Integer :lock_version, default: 0, null: false
  end
end

class Sequel::Database

  def create_notification_function
    create_function :notify, notification_function,
      language: :plpgsql, returns: :trigger, replace: true
  end

  def create_timestamp_trigger(table_name)
    create_trigger table_name, :timestamp, :moddatetime,
      args: :updated_at, each_row: true, events: :update
  end

  def drop_timestamp_trigger(table_name)
    drop_trigger table_name, :timestamp
  end

  def notification_function
    File.read(File.expand_path("../sql/notification.sql", __FILE__))
  end
end
