require 'ffi'
require 'discid/lib'
require 'discid/track_info'

module DiscId
  class Disc
    attr_reader :device

    def initialize
      pointer = Lib.new
      @handle = FFI::AutoPointer.new(pointer, Lib.method(:free))
      @read = false
    end

    def read(device, *features)
      @read = false
      device = self.class.default_device if device.nil?
      
      if not device.respond_to? :to_s
        raise TypeError, 'wrong argument type (expected String)'
      end
     
      @device = device.to_s
      flags = Lib.features_to_int features
      result = Lib.read @handle, @device, flags

      if result == 0
        raise Exception, Lib.get_error_msg(@handle)
      else
        @read = true
      end
    end

    def put(first_track, sectors, offsets)
      @read = false
      @device = nil
      last_track = offsets.length + 1 - first_track
      
      # discid_puts expects always an offsets array with exactly 100 elements.
      FFI::MemoryPointer.new(:int, 100) do |p|
        p.write_array_of_int([sectors] + offsets)
        result = Lib.put @handle, first_track, last_track, p
        
        if result == 0
          raise Exception, Lib.get_error_msg(@handle)
        else
          @read = true
        end
      end
    end

    def id
      return nil unless @read
      return Lib.get_id @handle
    end

    def freedb_id
      return nil unless @read
      return Lib.get_freedb_id @handle
    end
    
    def first_track_num
      return nil unless @read
      return Lib.get_first_track_num @handle
    end

    def last_track_num
      return nil unless @read
      return Lib.get_last_track_num @handle
    end

    def sectors
      return nil unless @read
      return Lib.get_sectors @handle
    end

    # Return the length of the disc in sectors.
    # 
    # Returns <tt>nil</tt> if no ID was yet read. 
    def seconds
      DiscId.sectors_to_seconds(sectors) if @read
    end

    def mcn
      return nil unless @read
      return Lib.get_mcn @handle
    end

    def submission_url
      return nil unless @read
      return Lib.get_submission_url @handle
    end

    # DiscId to String conversion. Same as calling the method id but guaranteed
    # to return a string.
    def to_s
      id.to_s
    end

    # Returns an array of TrackInfo objects. Each TrackInfo object contains
    # detailed information about the track.
    # 
    # If a block is given this method returns <tt>nil</tt> and instead iterates
    # over the block calling the block with one argument <tt>|track_info|</tt>.
    # 
    # Returns always <tt>nil</tt> if no ID was yet read. The block won't be
    # called in this case.
    def tracks
      if @read
        track_number = self.first_track_num - 1
        tracks = []
        
        while track_number < self.last_track_num do
          track_number += 1
          isrc = Lib.get_track_isrc(@handle, track_number)
          offset = Lib.get_track_offset(@handle, track_number)
          length = Lib.get_track_length(@handle, track_number)
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

  end
end
