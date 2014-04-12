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

# The code coverage is only supported for Ruby >= 1.9
if (RUBY_VERSION.split('.').map{|s|s.to_i} <=> [1.9.0]) >= 0
  require 'codeclimate-test-reporter'

  CodeClimate::TestReporter.start do
    add_filter "/test/"
  end
end
