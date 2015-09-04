# encoding: UTF-8

name 'mumble_server_test'
maintainer 'Xabier de Zuazo'
maintainer_email 'xabier@zuazo.org'
license 'Apache 2.0'
description 'This cookbook is used with test-kitchen to test the parent, '\
            'mumble_server cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

depends 'mumble_server'
