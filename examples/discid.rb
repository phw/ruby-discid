#!/usr/bin/env ruby
#
# Example script for MB-DiscID.
# 
# This script will read the disc ID from the default device and print
# the results. You can specify an alternate device to use by giving the
# device's name as the first command line argument.
# 
# Example:
#  ./discid.rb /dev/dvd
#
# $Id$

require 'mb-discid'

# Read the device name from the command line or use the default.
device = $*[0] ? $*[0] : MusicBrainz::DiscID.default_device

# Create a new DiscID object and read the disc information.
# In case of errors exit the application.
puts "Reading TOC from device '#{device}'."
begin
  disc = MusicBrainz::DiscID.new
  disc.read(device)
rescue Exception => e
  puts e
  exit(0)
end

# Print information about the disc:
print <<EOF

DiscID     : #{disc.id}
FreeDB ID  : #{disc.freedb_id}
First track: #{disc.first_track_num}
Last track : #{disc.last_track_num}
Sectors    : #{disc.sectors}
EOF

# Print information about individual tracks:
track = disc.first_track_num
disc.tracks do |offset, length|
  puts "Track #{track}: Offset #{offset}, Length #{length}"
  track += 1
end

# Print a submission URL that can be used to submit
# the disc ID to MusicBrainz.org.
puts "\nSubmit via #{disc.submission_url}"
