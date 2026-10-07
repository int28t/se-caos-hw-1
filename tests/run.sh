#!/bin/sh
set -eu
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
build_dir=${BUILD_DIR:-"$project_dir/build"}
cmake -S "$project_dir" -B "$build_dir" -DCMAKE_BUILD_TYPE=Debug -DENABLE_SANITIZERS=ON
cmake --build "$build_dir" --parallel
ctest --test-dir "$build_dir" --output-on-failure
for scenario in demo hand emergency compatible; do
    "$build_dir/crossroad" "$project_dir/data/$scenario.conf" "$project_dir/results/$scenario.log" >/dev/null
done
