#!/usr/bin/env bats

@test "murmur should be running with runit" {
  ps axu | grep 'runsv mumble-serve[r]'
}

@test "should log to runit log file" {
  LOG_FILE='/etc/service/mumble-server/log/main/current'
  [ -e "${LOG_FILE}" ] || LOG_FILE='/etc/service/murmur-server/log/main/current'
  grep 'Murmur .* running on' "${LOG_FILE}"
}
