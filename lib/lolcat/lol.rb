#
# lolcat (c)2011 moe@busyloop.net
#

#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

require "lolcat/version"
require 'paint'

module Lol
  STRIP_ANSI = Regexp.compile '\e\[(\d+)(;\d+)?(;\d+)?[m|K]', nil

  def self.rainbow(freq, i)
     red   = Math.sin(freq*i + 0) * 127 + 128
     green = Math.sin(freq*i + 2*Math::PI/3) * 127 + 128
     blue  = Math.sin(freq*i + 4*Math::PI/3) * 127 + 128
     "#%02X%02X%02X" % [ red, green, blue ]
  end

  def self.cat(fd, opts={})
    print "\e[?25l" if opts[:animate]
    fd.each do |line|
      opts[:os] += 1
      println(line, opts)
    end
    ensure
    print "\e[?25h" if opts[:animate]
  end

  def self.println(str, defaults={}, opts={})
    opts.merge!(defaults)
    str.chomp!
    str.gsub! STRIP_ANSI, '' if !str.nil? and ($stdout.tty? or opts[:force])
    str.gsub! "\t", "        "
    opts[:animate] ? println_ani(str, opts) : println_plain(str, opts)
    puts
  end

  private

  def self.println_plain(str, defaults={}, opts={})
    opts.merge!(defaults)
    str.chomp.chars.each_with_index do |c,i|
      print Paint[c, rainbow(opts[:freq], opts[:os]+i/opts[:spread])]
    end
  end

  def self.println_ani(str, opts={})
    return if str.empty?
    (1..opts[:duration]).each do |i|
      print "\e[#{str.length}D"
      opts[:os] += opts[:spread]
      println_plain(str, opts)
      sleep 1.0/opts[:speed]
    end
  end
end
