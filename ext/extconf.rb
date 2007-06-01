#!/usr/bin/env ruby

require 'mkmf'

if have_library('discid', 'discid_new')
  create_makefile('DiscID')
else
  puts 'Required library libdiscid not found.'
end