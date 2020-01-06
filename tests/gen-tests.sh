#!/usr/bin/env bash

find ./cases/ -mindepth 1 -maxdepth 2 -type d -print0 | xargs -0 -i% basename % | grep -vP 'data|README'  | xargs -i% bash -c "sed 's/@CASE_NAME@/%/g' tests/template > tests/%.at"
