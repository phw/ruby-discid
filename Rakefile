# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.
 
# Rakefile for RDiscID

require 'rubygems'
require 'rake/gempackagetask'

task :default do
  puts "Please see 'rake --tasks' for an overview of the available tasks."
end

# Packaging tasks: -------------------------------------------------------

PKG_NAME     = 'mb-discid'
PKG_VERSION  = '0.1.0'
PKG_SUMMARY  = 'Ruby bindings for libdiscid.'
PKG_AUTHOR   = 'Philipp Wolfer'
PKG_EMAIL    = 'phw@rubyforge.org'
PKG_HOMEPAGE = 'http://rbrainz.rubyforge.org'
PKG_DESCRIPTION = <<EOF
    Ruby bindings for libdiscid. See http://musicbrainz.org/doc/libdiscid
    for more information on libdiscid and MusicBrainz.
EOF
PKG_FILES = FileList[
  'Rakefile', 'LICENSE', 'README',
  'examples/**/*',
  'ext/**/*.{c,rb}'
]

spec = Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.name = PKG_NAME
  spec.version = PKG_VERSION
  spec.summary = PKG_SUMMARY
  spec.requirements << 'libdiscid (http://musicbrainz.org/doc/libdiscid)'
  spec.require_path = 'lib'
  spec.autorequire = spec.name
  spec.files = PKG_FILES
  spec.extensions << 'ext/extconf.rb'
  spec.description = PKG_DESCRIPTION
  spec.author = PKG_AUTHOR
  spec.email = PKG_EMAIL
  spec.homepage = PKG_HOMEPAGE
  spec.rubyforge_project = 'rbrainz'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar_gz= true
end

# Build tasks: -----------------------------------------------------------

desc 'Build all the extensions'
task :build do
  extconf_args = ''

  unless ENV['DISCID_DIR'].nil?
    extconf_args = "--with-discid-dir=#{ENV['DISCID_DIR']}"
  end

  cd 'ext' do
    unless system("ruby extconf.rb #{extconf_args}")
      STDERR.puts "ERROR: could not configure extension!\n" +
                  "\n#{INFO_NOTE}\n"
      break
    end

    unless system('make') or system('nmake')
      STDERR.puts 'ERROR: could not build extension!'
      break
    end
  end
end

desc 'Install (and build) extensions'
task :install => [:build] do
  cd 'ext' do
    unless system('make install')
      STDERR.puts 'ERROR: could not install extension!'
      break
    end
  end
end

desc 'Remove extension products'
task :clobber_build do
  FileList['ext/**/*'].each do |file|
    unless FileList['ext/**/*.{c,rb}'].include?(file)
      rm_r file if File.exists?(file)
    end
  end
end

desc 'Force a rebuild of the extension files'
task :rebuild => [:clobber_build, :build]

desc 'Remove all files created during the build process'
task :clobber => [:clobber_build, :clobber_package]

