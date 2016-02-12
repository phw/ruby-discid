# Changelog

## 1.2.0 (2016-02-12)
* `DiscId.sectors_to_seconds`: Truncate instead of round resulting float

## 1.1.2 (2016-02-11)
* Fixed first and last track being swapped in example readdiscid.rb
* Restricted dependencies for Ruby 1.8 to maintain compatibility
* Test against Ruby 2.3

## 1.1.1 (2015-08-27)
* Fixed gem file permissions

## 1.1.0 (2015-08-26)
* Fixed Disc#put handling of first_track being > 1

## 1.0.0 (2013-05-01)
* Final API and documentation cleanup.
* Fixed library loading on Windows and OSX.

## 1.0.0.rc2 (2013-04-29)
* Fixed loading libdiscid library

## 1.0.0.rc1 (2013-04-22)
* Support libdiscid versions 0.1.0 through 0.5.0
* Compatible with JRuby

## 1.0.0.a1 (2013-04-22)
* Use FFI instead of C module
* Completely overhauled API
* Full support for MCN, ISRC and libdiscid feature detection
* Renamed from mb-discid to just discid

## 0.2.0 (2013-02-17)
* Support for MCN and ISRC (requires libdiscid >= 0.3)

## 0.1.5 (2011-07-02)
* Added binding for get_webservice_url()
* Add lib path detection, allows out-of-the-box install when your
  libdiscid is in /usr/local (Matt Patterson)

## 0.1.4 (2009-11-19)
* Fixed calling read method without argument

## 0.1.3 (2009-11-19)
* Added singleton method sectors_to_seconds to convert sectors into seconds
* Added method seconds to retrieve disc length in seconds
* Added method track_info for accessing more detailed information about tracks
* Fixed building with Ruby 1.9 (Mihaly Csomay)

## 0.1.2 (2007-07-04)
* Support the method put to set the TOC information directly instead of
  reading it from a device.
* Fixed possible core dump if read was called twice and failed the
  second time.
* New to_s method (returns string representation of the ID itself).
* Complete RDoc documentation.

## 0.1.1 (2007-06-03)
* Minor changes to source to support MS compiler
* Provide Win32 binary gem
* Changed require of library to "require 'mb-discid'" (was "require 'DiscID'"
  before, which was likely to cause problems)

## 0.1.0 (2007-06-02)
* Initial release
