-- gtfs_routes

ALTER TABLE gtfs_routes
  ADD CONSTRAINT gtfs_route_types_fkey
  FOREIGN KEY (route_type)
  REFERENCES gtfs_route_types (route_type);

ALTER TABLE gtfs_routes
  ADD CONSTRAINT gtfs_routes_fkey
  FOREIGN KEY (feed_index, agency_id)
  REFERENCES gtfs_agency (feed_index, agency_id);

-- gtfs_calendar_dates

ALTER TABLE gtfs_calendar_dates
  ADD CONSTRAINT gtfs_calendar_fkey
  FOREIGN KEY (feed_index, service_index)
  REFERENCES gtfs_calendar (feed_index, service_index);

ALTER TABLE gtfs_fare_attributes
  ADD CONSTRAINT gtfs_fare_attributes_fkey
  FOREIGN KEY (feed_index, agency_id)
  REFERENCES gtfs_agency (feed_index, agency_id);

-- gtfs_fare_rules

ALTER TABLE gtfs_fare_rules
  ADD CONSTRAINT gtfs_fare_rules_service_fkey 
  FOREIGN KEY (feed_index, service_index)
  REFERENCES gtfs_calendar (feed_index, service_index);

ALTER TABLE gtfs_fare_rules
  ADD CONSTRAINT gtfs_fare_rules_fare_id_fkey
  FOREIGN KEY (feed_index, fare_id)
  REFERENCES gtfs_fare_attributes (feed_index, fare_id);

ALTER TABLE gtfs_fare_rules
  ADD CONSTRAINT gtfs_fare_rules_route_id_fkey
  FOREIGN KEY (feed_index, route_id)
  REFERENCES gtfs_routes (feed_index, route_id);

-- gtfs_trips

ALTER TABLE gtfs_trips
  ADD CONSTRAINT gtfs_trips_route_id_fkey
  FOREIGN KEY (feed_index, route_id)
  REFERENCES gtfs_routes (feed_index, route_id);

ALTER TABLE gtfs_trips
  ADD CONSTRAINT gtfs_trips_calendar_fkey
  FOREIGN KEY (feed_index, service_index)
  REFERENCES gtfs_calendar (feed_index, service_index);

-- gtfs_stop_times

ALTER TABLE gtfs_stop_times
  ADD CONSTRAINT gtfs_stop_times_trips_fkey
  FOREIGN KEY (feed_index, trip_index)
  REFERENCES gtfs_trips (feed_index, trip_index);

ALTER TABLE gtfs_stop_times
  ADD CONSTRAINT gtfs_stop_times_stops_fkey
  FOREIGN KEY (feed_index, stop_id)
  REFERENCES gtfs_stops (feed_index, stop_id);

-- gtfs_frequencies

ALTER TABLE gtfs_frequencies
  ADD CONSTRAINT gtfs_frequencies_trip_fkey
  FOREIGN KEY (feed_index, trip_index)
  REFERENCES gtfs_trips (feed_index, trip_index);

-- gtfs_transfers

ALTER TABLE gtfs_transfers
  ADD CONSTRAINT gtfs_transfers_from_stop_fkey
  FOREIGN KEY (feed_index, from_stop_id)
  REFERENCES gtfs_stops (feed_index, stop_id);

ALTER TABLE gtfs_transfers
  ADD CONSTRAINT gtfs_transfers_to_stop_fkey
  FOREIGN KEY (feed_index, to_stop_id)
  REFERENCES gtfs_stops (feed_index, stop_id);

ALTER TABLE gtfs_transfers
  ADD CONSTRAINT gtfs_transfers_from_route_fkey
  FOREIGN KEY (feed_index, from_route_id)
  REFERENCES gtfs_routes (feed_index, route_id);

ALTER TABLE gtfs_transfers
  ADD CONSTRAINT gtfs_transfers_to_route_fkey
  FOREIGN KEY (feed_index, to_route_id)
  REFERENCES gtfs_routes (feed_index, route_id);

ALTER TABLE gtfs_transfers
  ADD CONSTRAINT gtfs_transfers_service_fkey
  FOREIGN KEY (feed_index, service_index)
  REFERENCES gtfs_calendar (feed_index, service_index);
