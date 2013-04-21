require 'discid/lib'
require 'discid/disc'
require 'discid/version'

# The DiscId module allows calculating DiscIDs (MusicBrainz and freedb)
# for Audio CDs. Additionally the library can extract the MCN/UPC/EAN and
# the ISRCs from disc.
module DiscId

  # Read the disc in the given CD-ROM/DVD-ROM drive extracting only the
  # TOC and additionally specified features.
  #
  # This function reads the disc in the drive specified by the given device
  # identifier. If the device is `nil`, the default device, as returned by
  # {default_device}, is used.
  #
  # This function will always read the TOC, but additional features like `:mcn`
  # and `:isrc` can be set using the features parameter. You can set multiple
  # features.
  # 
  # Examples
  # --------
  # Read only the TOC:
  #    
  #     disc = DiscId.read(device)
  #
  # Read the TOC, MCN and ISRCs:
  #     
  #     disc = DiscId.read(device, :mcn, :isrc)
  #
  # @raise [TypeError] `device` can not be converted to a String.
  # @raise [Exception] Error reading from `device`. See Exception#message for
  #    error details.
  # @param device [String] The device identifier.
  # @param *features [:mcn, :isrc] List of features to use.
  #     :read is always implied.
  # @return [Disc]
  def self.read(device, *features)
    disc = Disc.new
    disc.read device, *features
    return disc
  end
    
  # Provides the TOC of a known CD.
  #
  # This function may be used if the TOC has been read earlier and you want to
  # calculate the disc ID afterwards, without accessing the disc drive. 
  #
  # @raise [Exception] The TOC could not be set. See Exception#message for
  #    error details.
  # @param first_track [Integer] The number of the first audio track on the
  #   disc (usually one).
  # @param sectors [Integer] The total number of sectors on the disc.
  # @param offsets [Array] An array with track offsets (sectors) for each track.
  # @return [Disc]
  def self.put(first_track, sectors, offsets)
    disc = Disc.new
    disc.put first_track, sectors, offsets
    return disc
  end
    
  # Return the name of the default disc drive for this operating system.
  #
  # @return [String] An operating system dependent device identifier
  def self.default_device
    Lib.default_device
  end

  # Check if a certain feature is implemented on the current platform.
  #
  # @param feature [:read, :mcn, :isrc]
  # @return [Boolean] True if the feature is implemented and false if not.
  def self.has_feature?(feature)
    feature = feature.to_sym if feature.respond_to? :to_sym
    result = Lib.has_feature feature if Lib::Features.symbols.include? feature
    return result == 1
  end

  # Converts sectors to seconds.
  # 
  # According to the red book standard 75 sectors are one second.
  #
  # @private
  # @param sectors [Integer] Number of sectors
  # @return [Integer] The seconds
  def self.sectors_to_seconds(sectors)
    return (sectors.to_f / 75).round
  end

end
