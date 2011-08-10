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
  def self.rainbow(freq, i)
     red   = Math.sin(freq*i + 0) * 127 + 128
     green = Math.sin(freq*i + 2*Math::PI/3) * 127 + 128
     blue  = Math.sin(freq*i + 4*Math::PI/3) * 127 + 128
     "#%02X%02X%02X" % [ red, green, blue ]
  end

  def self.whut(text, duration=12, delay=0.05, spread=8)
    (1..duration).each do |i|
      print "\e[#{text.length}D"
      text.chars.each_with_index do |c,j|
        print Paint[c, rainbow(0.3, i+j/spread)]
      end
      sleep delay
    end
    puts
  end

  def self.lput(str, offset, spread)
    print Paint[str, rainbow(0.3, offset/spread)]
  end

  def self.cat(fd, spread)
    i=0
    fd.each do |line|
      line.chars.each_with_index do |c,j|
        lput c, i+j, spread
      end
      i+=1
    end
  end
end
