# Ruby bindings for MusicBrainz libdiscid
[![Gem Version](https://badge.fury.io/rb/discid.svg)](http://badge.fury.io/rb/discid)
[![Maintainability](https://api.codeclimate.com/v1/badges/50e356f4260a127af75b/maintainability)](https://codeclimate.com/github/phw/ruby-discid/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/50e356f4260a127af75b/test_coverage)](https://codeclimate.com/github/phw/ruby-discid/test_coverage)

## About
ruby-discid provides Ruby bindings for the MusicBrainz DiscID library [libdiscid](http://musicbrainz.org/doc/libdiscid).
It allows calculating DiscIDs (MusicBrainz and freedb) for Audio CDs. Additionally
the library can extract the MCN/UPC/EAN and the ISRCs from disc.

ruby-discid supports all features from libdiscid 0.6, but will also work with
any earlier version. If a feature is unsupported in the libdiscid version used
ruby-discid will just return a default value. The version required for a feature
is documented in the [API documentation](http://www.rubydoc.info/github/phw/ruby-discid/master).

## Requirements
* Ruby >= 1.9.0
* RubyGems >= 1.3.6
* Ruby-FFI >= 1.6.0
* libdiscid >= 0.1.0

## Installation
Before installing ruby-discid make sure you have libdiscid installed. See
http://musicbrainz.org/doc/libdiscid for more information on how to do this.
For Windows see also the notes below.

### Installing with RubyGems
Installing ruby-discid is best done using RubyGems:

    gem install discid

### Installing from package repository
For some Linux distributions packages are available:

* [Arch Linux AUR package](https://aur.archlinux.org/packages/ruby-discid/)
* [Ubuntu PPA](https://launchpad.net/~musicbrainz-developers/+archive/ubuntu/stable)

### Install from source
You can also install from source. This requires RubyGems and Bundler installed.
First make sure you have installed bundler:

    gem install bundler

Then inside the ruby-discid source directory run:

    bundle install
    rake install

`bundle install` will install additional development dependencies (Rake,
Yard etc.). `rake install` will build the discid gem and install it.

### Windows installation notes
On Windows you will need `discid.dll` available in a place where Windows can
find it, see [Search Path Used by Windows to Locate a DLL](https://msdn.microsoft.com/en-us/library/7d83bc18.aspx).
You can install the `discid.dll` system wide, but it is recommended to place
it in the local working directory of your application.

Also the architecture (32 or 64 bit) of the DLL must match your Ruby version.
As the official build of libdiscid contains only a 32 bit version of `discid.dll`
it is recommended to use the 32 bit version of Ruby.

If you want or need to use 64 bit Ruby you will have to compile libdiscid
yourself. Refer to the [libdiscid install instructions](https://github.com/metabrainz/libdiscid/blob/master/INSTALL)
for further details.

## Usage

### Read only the TOC

```ruby
require 'discid'

# Specifying the device is optional. If omitted a platform
# specific default will be used.
device = "/dev/cdrom"
disc = DiscId.read(device)
puts disc.id
```

### Read the TOC, MCN and ISRCs

```ruby
require 'discid'

device = "/dev/cdrom"
disc = DiscId.read(device, :mcn, :isrc)

# Print information about the disc:
puts "DiscID      : #{disc.id}"
puts "FreeDB ID   : #{disc.freedb_id}"
puts "Total length: #{disc.seconds} seconds"
puts "MCN         : #{disc.mcn}"

# Print information about individual tracks:
disc.tracks do |track|
  puts "Track ##{track.number}"
  puts "  Length: %02d:%02d (%i sectors)" %
      [track.seconds / 60, track.seconds % 60, track.sectors]
  puts "  ISRC  : %s" % track.isrc
end
```

See the [API documentation](http://www.rubydoc.info/github/phw/ruby-discid/master)
of {DiscId} or the files in the `examples` directory for more usage information.

## Contribute
The source code for ruby-discid is available on
[GitHub](https://github.com/phw/ruby-discid).

Please report any issues on the
[issue tracker](https://github.com/phw/ruby-discid/issues).

## License
ruby-discid Copyright (c) 2007-2021 by Philipp Wolfer <ph.wolfer@gmail.com>

ruby-discid is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

See LICENSE for details.
