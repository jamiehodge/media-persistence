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
    create_function :notify, <<SQL, language: :plpgsql, returns: :trigger, replace: true
      BEGIN
        IF (TG_OP = 'DELETE') THEN
          PERFORM pg_notify(TG_TABLE_NAME, '{ \"id\": \"' || OLD.id || '\", \"event\": \"' || lower(TG_OP) || '\" }');
          RETURN OLD;
        ELSE
          PERFORM pg_notify(TG_TABLE_NAME, '{ \"id\": \"' || NEW.id || '\", \"event\": \"' || lower(TG_OP) || '\" }');
          RETURN NEW;
        END IF;
      END;
SQL
  end

  def create_notification_trigger(table_name)
    create_trigger table_name, :notify, :notify, each_row: true
  end

  def drop_notification_trigger(table_name)
    drop_trigger table_name, :notify
  end

  def create_timestamp_trigger(table_name)
    create_trigger table_name, :timestamp, :moddatetime,
      args: :updated_at, each_row: true, events: :update
  end

  def drop_timestamp_trigger(table_name)
    drop_trigger table_name, :timestamp
  end
end
