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

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << 'ext/' << '../ext/' << '../lib/'

require 'mb-discid'

# Read the device name from the command line or use the default.
device = $*[0] ? $*[0] : MusicBrainz::DiscID.default_device

# Create a new DiscID object and read the disc information.
# In case of errors exit the application.
puts "Reading TOC from device '#{device}'."
begin
  disc = MusicBrainz::DiscID.new
  disc.read(device)
  
  # Instead of reading from a device we could set the TOC directly:
  # disc.put(1, 82255, [150, 16157, 35932, 57527])
rescue Exception => e
  puts e
  exit(1)
end

# Print information about the disc:
print <<EOF

DiscID      : #{disc.id}
FreeDB ID   : #{disc.freedb_id}
First track : #{disc.first_track_num}
Last track  : #{disc.last_track_num}
Total length: #{disc.seconds} seconds
Sectors     : #{disc.sectors}
MCN         : #{disc.media_catalog_number}
EOF

# Print information about individual tracks:
disc.track_details do |track_info|
  puts "Track ##{track_info.number}"
  puts "  Length: %02d:%02d (%i sectors)" %
      [track_info.seconds / 60, track_info.seconds % 60, track_info.sectors]
  puts "  Start : %02d:%02d (sector %i)" %
      [track_info.start_time / 60, track_info.start_time % 60, track_info.start_sector]
  puts "  End   : %02d:%02d (sector %i)" %
      [track_info.end_time / 60, track_info.end_time % 60, track_info.end_sector]
  puts "  ISRC  : %s" % track_info.isrc
end

# Print a submission URL that can be used to submit
# the disc ID to MusicBrainz.org.
puts "\nSubmit via #{disc.submission_url}"
puts "\nWebservice #{disc.webservice_url}"
