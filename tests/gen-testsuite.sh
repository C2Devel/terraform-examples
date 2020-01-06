#!/usr/bin/env bash

echo '' > tests/testsuite.at
find ./cases/ -mindepth 1 -maxdepth 2 -type d -print0 | xargs -i% -0 basename % | xargs -i% bash -c "echo 'm4_include([%.at])' >> tests/testsuite.at"
