#!/usr/bin/env ruby
# $Id$

require 'mkmf'

if have_library('discid', 'discid_new')
  # Remove -MD from compiler flags on Windows.
  $CFLAGS.sub!('-MD', '') if RUBY_PLATFORM.include? 'win32'
  create_makefile('MB_DiscID')
else
  puts 'Required library libdiscid not found.'
end