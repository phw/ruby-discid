require 'discid/lib'
require 'discid/disc'
require 'discid/version'

module DiscId
  def self.read(device, *features)
    disc = Disc.new
    disc.read device, *features
    return disc
  end
    
  def self.put(first_track, sectors, offsets)
    disc = Disc.new
    disc.put first_track, sectors, offsets
    return disc
  end
    
  def self.default_device
    Lib.default_device
  end

  def self.has_feature?(feature)
    feature = feature.to_sym if feature.respond_to? :to_sym
    result = Lib.has_feature feature if Lib::Features.symbols.include? feature
    return result == 1
  end

  # Converts sectors to seconds.
  # 
  # According to the red book standard 75 sectors are one second.
  def self.sectors_to_seconds(sectors)
    return (sectors.to_f / 75).round
  end

end
