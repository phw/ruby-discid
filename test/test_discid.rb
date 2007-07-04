# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'mb-discid'

# Helper class which can't be converted into a string.
class NotAString
  
  private
  
  def to_s
  end

end

# Unit test for the MusicBrainz::DiscID class.
class TestDiscID < Test::Unit::TestCase

  def setup
    @fiction_disc_id     = 'Wn8eRBtfLDfM0qjYPdxrz.Zjs_U-'
    @fiction_first_track = 1
    @fiction_last_track  = 10
    @fiction_sectors     = 206535
    @fiction_offsets     = [150, 18901, 39738, 59557, 79152, 100126,
                            124833, 147278, 166336, 182560]
    @fiction_lengths     = [18751, 20837, 19819, 19595, 20974,
                            24707, 22445, 19058, 16224, 23975] 
  end

  def teardown
  end
  
  # Test reading the disc id from a device.
  # We would need some kind of small test data to do this.
  #def test_read
  #  assert false, "Not implemented yet"
  #end
  
  # Test how read reacts on different arguments.
  # Those reads should all fail, but they must never cause a segmentation fault.
  def test_read_invalid_arguments
    assert_raise(TypeError) {MusicBrainz::DiscID.new(NotAString.new)}
    assert_raise(Exception) {MusicBrainz::DiscID.new(1)}
    assert_raise(Exception) {MusicBrainz::DiscID.new('invalid_device')}
    assert_raise(Exception) {MusicBrainz::DiscID.new(:invalid_device)}
    assert_raise(ArgumentError) {MusicBrainz::DiscID.new(
                                           MusicBrainz::DiscID.default_device,
                                           'second argument')}
    
    disc = MusicBrainz::DiscID.new
    assert_raise(TypeError) {disc.read(NotAString.new)}
    assert_raise(Exception) {disc.read(1)}
    assert_raise(Exception) {disc.read('invalid_device')}
    assert_raise(Exception) {disc.read(:invalid_device)}
    assert_raise(ArgumentError) {disc.read(MusicBrainz::DiscID.default_device,
                                           'second argument')}
  end
  
  # Test calculation of the disc id if the TOC information
  # gets set by the put method.
  # All attributes should be nil after a failure, even if there was a
  # successfull put before.
  def test_put
    disc = MusicBrainz::DiscID.new
    assert_equal nil, disc.id
    assert_equal '', disc.to_s
    assert_equal nil, disc.first_track_num
    assert_equal nil, disc.last_track_num
    assert_equal nil, disc.sectors
    assert_equal nil, disc.tracks
    
    # First erroneous put
    assert_raise(Exception) {disc.put(-1, @fiction_sectors, @fiction_offsets)}
    assert_equal nil, disc.id
    assert_equal '', disc.to_s
    assert_equal nil, disc.first_track_num
    assert_equal nil, disc.last_track_num
    assert_equal nil, disc.sectors
    assert_equal nil, disc.tracks
    
    # Second successfull put
    assert_nothing_raised {disc.put(@fiction_first_track, @fiction_sectors,
                                    @fiction_offsets)}
    assert_equal @fiction_disc_id, disc.id
    assert_equal @fiction_disc_id, disc.to_s
    assert_equal @fiction_first_track, disc.first_track_num
    assert_equal @fiction_last_track, disc.last_track_num
    assert_equal @fiction_sectors, disc.sectors
    assert_equal @fiction_offsets, disc.tracks.map{|t| t[0]}
    assert_equal @fiction_lengths, disc.tracks.map{|t| t[1]}
    
    # Third erroneous put
    assert_raise(Exception) {disc.put(@fiction_first_track, @fiction_sectors, 
                                      Array.new(100, 1))}
    assert_equal nil, disc.id
    assert_equal '', disc.to_s
    assert_equal nil, disc.first_track_num
    assert_equal nil, disc.last_track_num
    assert_equal nil, disc.sectors
    assert_equal nil, disc.tracks
  end
  
end
