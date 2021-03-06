#!/usr/bin/env ruby
#
# Example script for DiscId.
#
# This script shows how to generate a disc ID for given TOC data
#
# Example:
#  ./discid.rb /dev/dvd

# Just make sure we can run this example from the command
# line even if DiscId is not yet installed properly.
$: << 'lib/' << 'ext/' << '../ext/' << '../lib/'

require 'discid'

offsets = [150, 44942, 61305, 72755, 96360, 130485, 147315, 164275, 190702, 205412, 220437]

disc = DiscId.put(1, 242457, offsets)


print <<EOF

Device      : #{disc.device}
DiscID      : #{disc.id}
FreeDB ID   : #{disc.freedb_id}
TOC string  : #{disc.toc_string}
First track : #{disc.first_track_number}
Last track  : #{disc.last_track_number}
Total length: #{disc.seconds} seconds
Sectors     : #{disc.sectors}

Submit via #{disc.submission_url}
EOF
