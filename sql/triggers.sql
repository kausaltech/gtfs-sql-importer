CREATE TRIGGER gtfs_trips_service_index_trigger BEFORE INSERT ON gtfs_trips
  FOR EACH ROW
  WHEN (NEW.service_index IS NULL)
  EXECUTE PROCEDURE gtfs_service_index_insert();

CREATE TRIGGER gtfs_calendar_service_index_trigger BEFORE INSERT ON gtfs_calendar
  FOR EACH ROW
  WHEN (NEW.service_index IS NULL)
  EXECUTE PROCEDURE gtfs_service_index_insert();

CREATE TRIGGER gtfs_calendar_dates_service_index_trigger BEFORE INSERT ON gtfs_calendar_dates
  FOR EACH ROW
  WHEN (NEW.service_index IS NULL)
  EXECUTE PROCEDURE gtfs_service_index_insert();

CREATE TRIGGER gtfs_trips_service_index_trigger BEFORE INSERT ON gtfs_trips
  FOR EACH ROW
  WHEN (NEW.trip_index IS NULL)
  EXECUTE PROCEDURE gtfs_trip_index_insert();

CREATE TRIGGER gtfs_trip_service_index_trigger BEFORE INSERT ON gtfs_trips
  FOR EACH ROW
  WHEN (NEW.service_index IS NULL)
  EXECUTE PROCEDURE gtfs_service_index_insert();

CREATE TRIGGER gtfs_shape_geom_trigger AFTER INSERT ON gtfs_shapes
    FOR EACH STATEMENT EXECUTE PROCEDURE gtfs_shape_update();

CREATE TRIGGER gtfs_stop_times_a_trip_index_trigger BEFORE INSERT ON gtfs_stop_times
  FOR EACH ROW
  WHEN (NEW.trip_index IS NULL)
  EXECUTE PROCEDURE gtfs_trip_index_insert();

CREATE TRIGGER gtfs_stop_times_b_dist_row_trigger BEFORE INSERT ON gtfs_stop_times
  FOR EACH ROW
  WHEN (NEW.shape_dist_traveled IS NULL)
  EXECUTE PROCEDURE gtfs_dist_insert();

CREATE TRIGGER gtfs_stop_times_dist_stmt_trigger AFTER INSERT ON gtfs_stop_times
  FOR EACH STATEMENT EXECUTE PROCEDURE gtfs_dist_update();

CREATE TRIGGER gtfs_stop_geom_trigger BEFORE INSERT OR UPDATE ON gtfs_stops
    FOR EACH ROW EXECUTE PROCEDURE gtfs_stop_geom_update();

CREATE TRIGGER gtfs_fare_rules_service_index_trigger BEFORE INSERT ON gtfs_fare_rules
  FOR EACH ROW
  WHEN (NEW.service_index IS NULL and NEW.service_id IS NOT NULL)
  EXECUTE PROCEDURE gtfs_service_index_insert();

CREATE TRIGGER gtfs_frequencies_trip_index_trigger BEFORE INSERT ON gtfs_frequencies
  FOR EACH ROW
  WHEN (NEW.trip_index IS NULL)
  EXECUTE PROCEDURE gtfs_trip_index_insert();

CREATE TRIGGER gtfs_transfers_service_index_trigger BEFORE INSERT ON gtfs_transfers
  FOR EACH ROW
  WHEN (NEW.service_index IS NULL and NEW.service_id is NOT NULL)
  EXECUTE PROCEDURE gtfs_service_index_insert();
