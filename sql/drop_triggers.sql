DROP TRIGGER IF EXISTS gtfs_shape_geom_trigger ON gtfs_shapes;

DROP TRIGGER IF EXISTS gtfs_calendar_service_index_trigger ON gtfs_calendar;

DROP TRIGGER IF EXISTS gtfs_calendar_dates_service_index_trigger ON gtfs_calendar_dates;

DROP TRIGGER IF EXISTS gtfs_trips_trip_index_trigger ON gtfs_trips;

DROP TRIGGER IF EXISTS gtfs_trips_service_index_trigger ON gtfs_trips;

DROP TRIGGER IF EXISTS gtfs_stop_times_a_trip_index_trigger ON gtfs_stop_times;

DROP TRIGGER IF EXISTS gtfs_stop_times_b_dist_row_trigger ON gtfs_stop_times;

DROP TRIGGER IF EXISTS gtfs_stop_times_dist_stmt_trigger ON gtfs_stop_times;

DROP TRIGGER IF EXISTS gtfs_stop_geom_trigger ON gtfs_stops;
