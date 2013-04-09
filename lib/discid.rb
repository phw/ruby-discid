require 'ffi'
require 'discid/api'
require 'discid/track_info'
require 'discid/version'

module DiscId
  class DiscId
    def initialize
      pointer = Api::new
      @handle = FFI::AutoPointer.new(pointer, Api.method(:free))
      @read = false
    end

    def read(device, *features)
      device = DiscId.default_device if device.nil?
      if not device.respond_to? :to_s
        raise TypeError, 'wrong argument type (expected String)'
      end
     
      # TODO: Handle features
      result = Api::read @handle, device, 0

      if result == 0
        @read = false
        raise Exception, Api::get_error_msg(@handle)
      else
        @read = true
      end
    end

    def id
      return nil unless @read
      return Api::get_id @handle
    end

    def freedb_id
      return nil unless @read
      return Api::get_freedb_id @handle
    end
    
    def first_track_num
      return nil unless @read
      return Api::get_first_track_num @handle
    end

    def last_track_num
      return nil unless @read
      return Api::get_last_track_num @handle
    end

    def sectors
      return nil unless @read
      return Api::get_sectors @handle
    end

    # Return the length of the disc in sectors.
    # 
    # Returns <tt>nil</tt> if no ID was yet read. 
    def seconds
      DiscId.sectors_to_seconds(sectors) if @read
    end

    def mcn
      return nil unless @read
      return Api::get_mcn @handle
    end

    def submission_url
      return nil unless @read
      return Api::get_submission_url @handle
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
          isrc = Api::get_track_isrc(@handle, track_number)
          offset = Api::get_track_offset(@handle, track_number)
          length = Api::get_track_length(@handle, track_number)
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
