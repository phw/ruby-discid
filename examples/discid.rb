#!/usr/bin/env ruby

require 'mb-discid'

# Read the device name from the command line or use the default.
device = $*[0] ? $*[0] : MusicBrainz::DiscID.default_device

disc = MusicBrainz::DiscID.new
disc.read(device)

print <<EOF
DiscID     : #{disc.id}
Submit via : #{disc.submission_url}
FreeDB ID  : #{disc.freedb_id}
First track: #{disc.first_track_num}
Last track : #{disc.last_track_num}
Sectors    : #{disc.sectors}
EOF

track = disc.first_track_num
disc.tracks do |offset, length|
  puts "Track #{track}: Offset #{offset}, Length #{length}"
  track += 1
end

puts disc.tracks.collect{|v| v[0]}.inspect