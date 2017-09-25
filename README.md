# About
Quick & easy import of GTFS data into a PostgreSQL database.

* [GTFS (General Transit Feed Specification)](http://code.google.com/transit/spec/transit_feed_specification.html)
* [Transitfeed](http://transitfeeds.com) (index and archive of GTFS data sets)

## Initial Import

This importer uses a Makefile to organize a series of SQL commands. The file `src/load.sh` is a shell script that does the heavy lifting of loading the contents of a GTFS zip file into a PostgreSQL database.

Before importing data, set up database with:
```
make init PG_DATABASE=mydbname
```
This will create the necessary tables, as well as useful indices and foreign keys. (It will create a database named `mydbname` if one does not exist).

Next, download a ZIP file containing a GTFS feed. You do not need to decompress it to import it.

To import the GTFS dataset in file named `gtfs.zip` into a local Postgres database named `mydbname`:
````
make load GTFS=gtfs.zip PG_DATABASE=mydbname
````

Place connection parameters in the `PSQLFLAGS` variable:
````
make load GTFS=gtfs.zip PG_DATABASE=mydbname PSQLFLAGS="-h example.com -U user"
````

For large feeds, you may find that loading is faster with indices. Don't forget to add them back, or all your queries will be very slow:
````
make drop_indices load add_indices GTFS=gtfs.zip PG_DATABASE=mydbname
````

## Feed indexes

GTFS data is regularly updated, and it's reasonable to want to include multiple iterations in the same database. This tool includes a `feed_index` column in each table. This index is part of the primary key of each table.

## Troubleshooting common errors in GTFS data

Most GTFS data has errors in it, so you will likely encounter an error when running the step above.

### Extra column
```
ERROR:  column "example_column" of relation "gtfs_example" does not exist
```
Some GTFS data providers add non-standard columns to their files. Consider adding the column to `sql/schema.sql` and submitting a pull request.
Solution:
```
psql PG_DATABASE -c 'ALTER TABLE gtfs_example ADD COLUMN example_column text'
```

### Null data
```
ERROR:  null value in column "example_id" violates not-null constraint
```
This might occur if an "id" column (e.g. `route_id`) is improperly empty. One solution: edit the file to add a non-empty value.
Another solution: drop indices from the database and reload the data:
```
make drop_indices load PG_DATABASE=mydb
```
Then edit the database to add a non-empty value and recreate the indices (`make add_indices PG_DATABASE=mydb`).

# License
Released under the MIT (X11) license. See LICENSE in this directory.
