#!/usr/bin/env bash

if (( $# == 0 )); then
  printf '%s\n' 'Please provide an element as an argument.'
  exit 0
fi

row=$(psql -X -qAt -F '|' -v ON_ERROR_STOP=1 \
  -U freecodecamp -d periodic_table -v "lookup=$1" <<'SQL'
SELECT e.atomic_number, e.name, e.symbol, t.type,
       p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements AS e
JOIN properties AS p USING (atomic_number)
JOIN types AS t USING (type_id)
WHERE e.atomic_number::text = :'lookup'
   OR e.symbol = :'lookup'
   OR e.name = :'lookup';
SQL
) || exit 1

if [[ -z "$row" ]]; then
  printf '%s\n' 'I could not find that element in the database.'
  exit 0
fi

IFS='|' read -r number name symbol type mass melting boiling <<< "$row"
printf "The element with atomic number %s is %s (%s). It's a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.\n" \
  "$number" "$name" "$symbol" "$type" "$mass" "$name" "$melting" "$boiling"
