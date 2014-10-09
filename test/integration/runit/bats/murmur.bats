#!/usr/bin/env bats

@test "murmur should be listening in the correct port" {
  lsof -itcp:'64738' -a -c'murmurd' -u'mumble-server'
}

@test "should set welcometext in murmur.ini" {
  grep '^welcometext=.*Welcome to this server' /etc/murmur/murmur.ini
}

@test "should escape username regexp correctly" {
  grep -F '[-=\\w\\[\\]\\{\\}\\(\\)\\@\\|\\.]+' /etc/murmur/murmur.ini
}
