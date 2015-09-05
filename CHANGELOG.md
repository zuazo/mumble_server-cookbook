CHANGELOG for mumble_server
===========================

This file is used to list changes made in each version of `mumble_server`.

## v0.2.0 (2015-09-05)

* Disable Ice by default.
* Fix Ubuntu `15.04` support.
* Improve platform support using `node['platform_family']` node attribute.
* Update chef links to use *chef.io* domain.
* Update contact information and links after migration.
* Add `mumble_server_supw` ChefSpec locator.
* metadata: Add `source_url` and `issues_url` links.

* Documentation:
 * Add license headers to files.
 * README:
  * Murmur documentation links added.
  * Use markdown tables.
  * Improve description.
  * Add GitHub badge.
  * Fix syntax errors in examples.
  * Move ChefSpec matchers documentation to the README.

* Testing:
 * Integrate tests with coveralls.
 * ChefSpec tests: Some `::File` stubs simplified.
 * Gemfile update: including RuboCop to `0.33.0`.
 * Move ChefSpec tests to *test/unit*.
 * Use `SoloRunner` for ChefSpec tests.
 * Integrate tests with `should_not` gem.
 * Replace all bats tests by Serverspec tests.
 * Fix [runit#142](https://github.com/hw-cookbooks/runit/issues/142) using cookbook version `1.6.0`.
 * Add .kitchen.docker.yml file.

## v0.1.0 (2014-10-10)

* Initial release of `mumble_server`.
