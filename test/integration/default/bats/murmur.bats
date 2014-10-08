#!/usr/bin/env bats

@test "murmur should be listening in the correct port" {
  lsof -itcp:'64738' -a -c'murmurd' -u'mumble-server'
}
