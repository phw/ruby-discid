#!/usr/bin/env ruby

require 'mkmf'

LIBDIR = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']

$CFLAGS << " #{ENV["CFLAGS"]}"
$LIBS << " #{ENV["LIBS"]}"

# totally thieved from Nokogiri's extconf.rb
if RbConfig::CONFIG['target_os'] =~ /mswin32/
  # There's no default include/lib dir on Windows. Let's just add the Ruby ones
  # and resort on the search path specified by INCLUDE and LIB environment
  # variables
  HEADER_DIRS = [INCLUDEDIR]
  LIB_DIRS = [LIBDIR]

else
  HEADER_DIRS = [
    # First search /opt/local for macports
    '/opt/local/include',

    # Then search /usr/local for people that installed from source
    '/usr/local/include',

    # Check the ruby install locations
    INCLUDEDIR,

    # Finally fall back to /usr
    '/usr/include',
  ]

  LIB_DIRS = [
    # First search /opt/local for macports
    '/opt/local/lib',

    # Then search /usr/local for people that installed from source
    '/usr/local/lib',

    # Check the ruby install locations
    LIBDIR,

    # Finally fall back to /usr
    '/usr/lib',
  ]
end

dir_config('discid', HEADER_DIRS, LIB_DIRS)

if have_library('discid', 'discid_new') or
   have_library('discid.dll', 'discid_new')
  headers = ['discid/discid.h']
  have_func('discid_get_mcn', headers)
  have_func('discid_get_track_isrc', headers)
  # Remove -MD from compiler flags on Windows.
  $CFLAGS.sub!('-MD', '') if RUBY_PLATFORM.include? 'win32'
  create_makefile('MB_DiscID')
else
  puts 'Required library libdiscid not found.'
end
