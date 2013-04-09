module DiscId

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
      DiscId.sectors_to_seconds(sectors)
    end
      
    # Start position of the track on the disc in seconds.
    def start_time
      DiscId.sectors_to_seconds(start_sector)
    end
    
    # End position of the track on the disc in seconds.
    def end_time
      DiscId.sectors_to_seconds(end_sector)
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
end
