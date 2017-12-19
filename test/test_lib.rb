# Copyright (C) 2013-2014 Philipp Wolfer
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

require_relative 'helper'
require 'test/unit'
require 'discid/lib'

class TestTrack < Test::Unit::TestCase
  def test_features_to_int
    assert_equal 1, DiscId::Lib.features_to_int([:read])
  end

  def test_features_to_int_no_features
    assert_equal 0, DiscId::Lib.features_to_int([])
  end

  def test_features_to_int_as_strings
    assert_equal 1, DiscId::Lib.features_to_int(['read'])
  end

  def test_features_to_int_ignores_unknown
    assert_equal 1, DiscId::Lib.features_to_int([:read, :fake])
  end

  def test_has_feature
    assert_equal 1, DiscId::Lib.has_feature(:read)
  end
end
