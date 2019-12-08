#!/bin/bash
set -e

# This script takes three arguments:
# - A zip file containing gtfs files
# - A schema name
# - A list of tables to import (e.g. "agency" to import agency.txt to SCHEMA.agency)
ZIP="$1"
shift; SCHEMA="$1"
shift; TABLES="$*"
FILES=$(unzip -l "${ZIP}" | awk '{print $NF}' | grep .txt)

# Called with two args: name of table and feed index
function import_stdin()
{
    local hed
    # remove possible BOM
    hed=$(unzip -p "$ZIP" "${1}.txt" | head -n 1 | awk '{sub(/^\xef\xbb\xbf/,"")}{print}')
    # Add unknown custom columns as text fields
    echo "$hed" \
        | awk -v schema=$SCHEMA -v FS=, -v table="$1" '{for (i = 1; i <= NF; i++) print "ALTER TABLE " schema "." table " ADD COLUMN IF NOT EXISTS " $i " TEXT;"}' \
        | psql

    echo "COPY ${SCHEMA}.${1}" 1>&2
    unzip -p "$ZIP" "${1}.txt" \
        | awk '{ sub(/\r$/, ""); sub("^\"\",", ","); gsub(",\"\"", ","); gsub(/,[[:space:]]+/, ","); if (NF > 0) print }' \
        | psql -c "BEGIN;
            CREATE TEMPORARY TABLE temp_gtfs (LIKE ${SCHEMA}.${1} EXCLUDING CONSTRAINTS EXCLUDING INDEXES);
            ALTER TABLE temp_gtfs DROP COLUMN feed_index CASCADE;
            COPY temp_gtfs (${hed}) FROM STDIN WITH DELIMITER AS ',' HEADER CSV;
            INSERT INTO ${SCHEMA}.${1} SELECT ${2}, * FROM temp_gtfs ON CONFLICT (${1}_pkey) DO NOTHING;
            COMMIT;"
}

# Check if this archive already exists in the db
possible_feed_index=$(psql -A -t -c "SELECT feed_index FROM ${SCHEMA}.feed_info WHERE feed_file = '$1'")
# If not, import the feed_info
if [ -z $possible_feed_index ]; then

    ADD_DATES=
    # Insert feed info
    if [[ "${FILES/feed_info}" != "$FILES" ]]; then
        # The archive includes "feed_info", so load that into the table
        echo "Loading feed_info from dataset"
        import_stdin "feed_info"
        psql -c "UPDATE ${SCHEMA}.feed_info SET feed_file = '$1' WHERE feed_index = (SELECT max(feed_index) FROM ${SCHEMA}.feed_info)"
    else
        ADD_DATES=true
        # get the min and max calendar dates for this
        echo "No feed_info file found, constructing one"
        echo "INSERT INTO ${SCHEMA}.feed_info" 1>&2
        psql -c "INSERT INTO ${SCHEMA}.feed_info (feed_file) VALUES ('$1');"
    fi

    # Save the current feed_index
    feed_index=$(psql -A -t -c "SELECT max(feed_index) FROM ${SCHEMA}.feed_info")

else
    # Save the previously-inserted feed_index
    feed_index=$possible_feed_index
fi

echo "SET feed_index = $feed_index" 1>&2

# for each table, check if file exists
for table in $TABLES; do
    if [[ ${FILES/${table}.txt} != "$FILES" ]]; then
        # set default feed_index
        psql -c "ALTER TABLE ${SCHEMA}.${table} ALTER COLUMN feed_index SET DEFAULT ${feed_index}"

        # read it into db
        import_stdin "$table"

        # unset default feed_index
        psql -c "ALTER TABLE ${SCHEMA}.${table} ALTER COLUMN feed_index DROP DEFAULT"
    fi
done

if [ -n "$ADD_DATES" ]; then
    echo "UPDATE ${SCHEMA}.feed_info"
    psql -c "UPDATE ${SCHEMA}.feed_info SET feed_start_date=s, feed_end_date=e FROM (SELECT MIN(start_date) AS s, MAX(end_date) AS e FROM ${SCHEMA}.calendar WHERE feed_index=${feed_index}) a WHERE feed_index = ${feed_index}"
else
    psql -c "UPDATE ${SCHEMA}.feed_info SET feed_file ='${ZIP}' WHERE feed_index = ${feed_index}"
fi
