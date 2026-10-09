#!/usr/bin/env bash
# simple-interest.sh - Calculate simple interest.
# Usage: ./simple-interest.sh <principal> <rate> <time>
#   principal : amount of money
#   rate      : annual interest rate in percent
#   time      : time in years
# Formula: SI = (P * R * T) / 100
#
# Licensed under the Apache License, Version 2.0.

set -euo pipefail

usage() {
  echo "Usage: $0 <principal> <rate> <time>" >&2
  echo "  principal : amount of money (e.g. 10000)" >&2
  echo "  rate      : annual interest rate in percent (e.g. 5)" >&2
  echo "  time      : time in years (e.g. 2)" >&2
}

is_number() {
  [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -eq 3 ]]; then
  principal=$1; rate=$2; time=$3
elif [[ $# -eq 0 ]]; then
  read -r -p "Enter principal: " principal
  read -r -p "Enter rate (% per annum): " rate
  read -r -p "Enter time (years): " time
else
  usage
  exit 1
fi

for value in "$principal" "$rate" "$time"; do
  if ! is_number "$value"; then
    echo "Error: '$value' is not a valid non-negative number." >&2
    usage
    exit 1
  fi
done

awk -v p="$principal" -v r="$rate" -v t="$time" 'BEGIN {
  si = (p * r * t) / 100
  printf "Principal       : %s\n", p
  printf "Rate (%% p.a.)   : %s\n", r
  printf "Time (years)    : %s\n", t
  printf "Simple Interest : %.2f\n", si
  printf "Total Amount    : %.2f\n", p + si
}'
