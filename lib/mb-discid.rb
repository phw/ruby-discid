# Just a helper file to allow loading the MB-DiscID library with
# <tt>require 'mb-discid'</tt>, which is the only recommended way
# to load the library.
# 
# This file may even provide extensions to the library in the future
# to avoid to have to write everything in C.
# 
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007-2013, Philipp Wolfer
# License::   MB-DiscID is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'MB_DiscID.so'

module MusicBrainz

  # Class to calculate a MusicBrainz DiscID from an audio CD in the drive.
  # 
  # This is basically an interface to the libdiscid C library
  # (http://musicbrainz.org/doc/libdiscid).
  # 
  # == Usage
  # === Basic Usage:
  #  
  #  require 'mb-discid'
  #  
  #  # Create a new DiscID object.
  #  disc = MusicBrainz::DiscID.new
  #  
  #  # Read the TOC from the default device.
  #  # An audio CD must be inserted in the drive. An exception will be thrown
  #  # if the CD can't be read.
  #  begin
  #    disc.read
  #  rescue Exception => e
  #    puts e
  #    exit(1)
  #  end
  #  
  #  # Print information about the disc:
  #  print <<EOF
  #  DiscID      : #{disc.id}
  #  Submit via  : #{disc.submission_url}
  #  FreeDB ID   : #{disc.freedb_id}
  #  First track : #{disc.first_track_num}
  #  Last track  : #{disc.last_track_num}
  #  Total length: #{disc.seconds} seconds
  #  Sectors     : #{disc.sectors}
  #  MCN         : #{disc.media_catalog_number}
  #  EOF
  #  
  #  # Print information about individual tracks:
  #  disc.track_details do |track_info|
  #    puts "Track ##{track_info.number}"
  #    puts "  Length: %02d:%02d (%i sectors)" %
  #       [track_info.seconds / 60, track_info.seconds % 60, track_info.sectors]
  #    puts "  Start : %02d:%02d (sector %i)" % 
  #       [track_info.start_time / 60, track_info.start_time % 60, track_info.start_sector]
  #    puts "  End   : %02d:%02d (sector %i)" %
  #       [track_info.end_time / 60, track_info.end_time % 60, track_info.end_sector]
  #    puts "  ISRC  : %s" % track_info.isrc
  #  end
  #  
  #  # Print a submission URL that can be used to submit
  #  # the disc ID to MusicBrainz.org.
  #  puts "\nSubmit via #{disc.submission_url}"
  #  
  # === Specifying the device to read from:
  # 
  #  # Create a new DiscID object and read the disc in /dev/dvd:
  #  disc = MusicBrainz::DiscID.new
  #  disc.read('/dev/dvd')
  #  
  #  # Create a new DiscID object and directly read the disc in /dev/dvd:
  #  disc = MusicBrainz::DiscID.new('/dev/dvd')
  #  
  #  # Create a new DiscID object and directly read the disc in the platform's
  #  # default device:
  #  disc = MusicBrainz::DiscID.new(MusicBrainz::DiscID.default_device)
  #  
  # === Calculating the DiscID for a given TOC
  # 
  #  disc = MusicBrainz::DiscID.new
  #  
  #  first_track   = 1
  #  sectors       = 224556
  #  track_offsets = [150, 9078, 13528, 34182, 53768, 70987, 96424,
  #                   118425, 136793, 159514, 179777, 198006]
  #  
  #  disc.put(first_track, sectors, track_offsets)
  #  puts disc.id # Should print "T_prJXQSrqbnH8OE.dgOKsHm5Uw-"
  #  
  class DiscID
  
    # This class holds information about a single track.
    # 
    # Currently this includes the following fields:
    # [number]       The number of the track on the disc.
    # [sectors]      Length of the track in sectors.
    # [start_sector] Start position of the track on the disc in sectors.
    # [end_sector]   End position of the track on the disc in sectors.
    # [seconds]      Length of the track in seconds.
    # [start_time]   Start position of the track on the disc in seconds.
    # [end_time]     End position of the track on the disc in seconds.
    # [isrc]         The track's ISRC (International Standard Recordings Code)
    #                if available.
    # 
    # You can access all fields either with directly or with the square bracket
    # notation:
    # 
    #  track = TrackInfo.new(1, 150, 16007)
    #  puts track.sectors   # 16007
    #  puts track[:sectors] # 16007
    #  
    # See:: DiscID#track_details
    class TrackInfo
      
      # The number of the track on the disc.
      attr_reader :number
      
      # Length of the track in sectors.
      attr_reader :sectors
      
      # Start position of the track on the disc in sectors.
      attr_reader :start_sector
      
      # ISRC number of the trac
      attr_reader :isrc
      
      # Returns a new TrackInfo.
      def initialize(number, offset, length, isrc)
        @number = number
        @start_sector = offset
        @sectors = length
        @isrc = isrc
      end
      
      # End position of the track on the disc in sectors.
      def end_sector
        start_sector + sectors
      end
      
      # Length of the track in seconds.
      def seconds
        DiscID.sectors_to_seconds(sectors)
      end
      
      # Start position of the track on the disc in seconds.
      def start_time
        DiscID.sectors_to_seconds(start_sector)
      end
      
      # End position of the track on the disc in seconds.
      def end_time
        DiscID.sectors_to_seconds(end_sector)
      end
      
      # Allows access to all fields similar to accessing values in a hash.
      # 
      # Example:
      #  track = TrackInfo.new(1, 150, 16007)
      #  puts track.sectors   # 16007
      #  puts track[:sectors] # 16007
      def [](key)
        if [:number, :sectors, :start_sector, :end_sector,
            :seconds, :start_time, :end_time].include?(key.to_sym)
          method(key).call
        end
      end
      
      # Converts the TrackInfo into a Hash.
      def to_hash
        {
        :sectors      => sectors,
        :start_sector => start_sector,
        :end_sector   => end_sector,
        :seconds      => seconds,
        :start_time   => start_time,
        :end_time     => end_time,
        :isrc         => isrc,
        }
      end
      
    end
    
    # DiscID to String conversion. Same as calling the method id but guaranteed
    # to return a string.
    def to_s
      id.to_s
    end
    
    # Return the length of the disc in sectors.
    # 
    # Returns <tt>nil</tt> if no ID was yet read. 
    def seconds
      DiscID.sectors_to_seconds(sectors) unless @read == false
    end
    
    # Returns an array of TrackInfo objects. Each TrackInfo object contains
    # detailed information about the track.
    # 
    # If a block is given this method returns <tt>nil</tt> and instead iterates
    # over the block calling the block with one argument <tt>|track_info|</tt>.
    # 
    # Returns always <tt>nil</tt> if no ID was yet read. The block won't be
    # called in this case.
    def track_details
      unless @read == false
        track_number = self.first_track_num - 1
        tracks = []
        
        self.tracks do |offset, length|
          track_number += 1
          isrc = self.isrc(track_number)
          track_info = TrackInfo.new(track_number, offset, length, isrc)
          
          if block_given?
            yield track_info
          else
            tracks << track_info
          end
        end
        
        return tracks unless block_given?
      end
    end
    
    # Converts sectors to seconds.
    # 
    # According to the red book standard 75 sectors are one second.
    def self.sectors_to_seconds(sectors)
      return (sectors.to_f / 75).round
    end
    
  end

end
