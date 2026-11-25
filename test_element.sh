#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"

[[ "$(./element.sh)" == 'Please provide an element as an argument.' ]]
[[ "$(./element.sh Xx)" == 'I could not find that element in the database.' ]]

hydrogen="The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
for input in 1 H Hydrogen; do
  [[ "$(./element.sh "$input")" == "$hydrogen" ]]
done

echo 'Element lookup checks passed.'
