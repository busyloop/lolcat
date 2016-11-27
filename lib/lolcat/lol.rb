# Copyright (c) 2016, moe@busyloop.net
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the lolcat nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require "lolcat/version"
require 'paint'

module Lol
  STRIP_ANSI = Regexp.compile '\e\[[\d;]*[m|K]', nil

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
    esc = false
    opts.merge!(defaults)
    str.chomp.chars.each_with_index do |c,i|
      if esc
        if c == "H" or c == "G" or c == "P" or c =="K" or c == "h" or c == "l" or c == "r" or c == "m" or c == "J" or c =="d"
          esc = false
        end
        print c
      elsif c == "\e"
        esc = true
        print c
      elsif c == "\r" or c == "\b"
        print c
      else
        print Paint[c, rainbow(opts[:freq], opts[:os]+i/opts[:spread])]
      end
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
