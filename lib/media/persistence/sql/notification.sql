BEGIN
  IF (TG_OP = 'DELETE') THEN
    PERFORM pg_notify(TG_TABLE_NAME, '{ \"id\": \"' || OLD.id || '\", \"event\": \"' || lower(TG_OP) || '\" }');
    RETURN OLD;
  ELSE
    PERFORM pg_notify(TG_TABLE_NAME, '{ \"id\": \"' || NEW.id || '\", \"event\": \"' || lower(TG_OP) || '\" }');
    RETURN NEW;
  END IF;
END;
