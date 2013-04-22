# Copyright (C) 2008 - 2013 Philipp Wolfer
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


module DiscId

  # This class holds information about a single track.
  # 
  # Currently this includes the following fields:
  #
  # * number:       The number of the track on the disc.
  # * sectors:      Length of the track in sectors.
  # * start_sector: Start position of the track on the disc in sectors.
  # * end_sector:   End position of the track on the disc in sectors.
  # * seconds:      Length of the track in seconds.
  # * start_time:   Start position of the track on the disc in seconds.
  # * end_time:     End position of the track on the disc in seconds.
  # * isrc:         The track's ISRC (International Standard Recordings Code)
  #                if available.
  # 
  # You can access all fields either directly or with the square bracket
  # notation:
  # 
  #     track = TrackInfo.new(1, 150, 16007)
  #     puts track.sectors   # 16007
  #     puts track[:sectors] # 16007
  #  
  # @see DiscId::Disc#tracks
  class TrackInfo
      
    # The number of the track on the disc.
    #
    # @return [Integer]
    attr_reader :number
    
    # Length of the track in sectors.
    #
    # @return [Integer]
    attr_reader :sectors
    
    # Start position of the track on the disc in sectors.
    #
    # @return [Integer]
    attr_reader :start_sector
    
    # ISRC number of the track.
    #
    # @note libdiscid >= 0.3.0 required. Older versions will always return nil.
    #     Not available on all platforms, see
    #     {http://musicbrainz.org/doc/libdiscid#Feature_Matrix}.
    #
    # @return [String]
    attr_reader :isrc
    
    # Returns a new TrackInfo.
    def initialize(number, offset, length, isrc)
      @number = number
      @start_sector = offset
      @sectors = length
      @isrc = isrc
    end
      
    # End position of the track on the disc in sectors.
    #
    # @return [Integer]
    def end_sector
      start_sector + sectors
    end
      
    # Length of the track in seconds.
    #
    # @return [Integer]
    def seconds
      DiscId.sectors_to_seconds(sectors)
    end
      
    # Start position of the track on the disc in seconds.
    #
    # @return [Integer]
    def start_time
      DiscId.sectors_to_seconds(start_sector)
    end
    
    # End position of the track on the disc in seconds.
    #
    # @return [Integer]
    def end_time
      DiscId.sectors_to_seconds(end_sector)
    end
      
    # Allows access to all fields similar to accessing values in a hash.
    # 
    # Example:
    #
    #     track = TrackInfo.new(1, 150, 16007)
    #     puts track.sectors   # 16007
    #     puts track[:sectors] # 16007
    def [](key)
      if [:number, :sectors, :start_sector, :end_sector,
          :seconds, :start_time, :end_time].include?(key.to_sym)
        method(key).call
      end
    end
    
    # Converts the TrackInfo into a Hash.
    #
    # @return [Hash]
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
end
