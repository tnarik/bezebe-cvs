#Changelog

## next
* Working towards a better documentation (changelog, readme, etc…)
* Connection configuration can now be performed during the initialization, not necessarily using `#connect`.
* Connection is performed using `Client.ensureConnection` instead of `Connection.open`, which correctly times out when the server doesn't respond (as when testing with some web servers).

## 0.0.1 (2012/10/31)
* Added a rough implementation of `#connect`, a initial RSpec for `#connect` and light documentation.

## 0.0.0 (2012/10/19)
* Initial gemification of code so that the project is available in [Rubygems](https://rubygems.org/gems/bezebe-cvs) and it can start to be integrated with other projects.