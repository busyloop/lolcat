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
  ANSI_ESCAPE = /((?:\e(?:[ -\/]+.|[\]PX^_][^\a\e]*|\[[0-?]*.|.))*)(.?)/m
  INCOMPLETE_ESCAPE = /\e(?:[ -\/]*|[\]PX^_][^\a\e]*|\[[0-?]*)$/

  @paint_detected_mode = Paint.detect_mode

  def self.rainbow(freq, i)
     red   = Math.sin(freq*i + 0) * 127 + 128
     green = Math.sin(freq*i + 2*Math::PI/3) * 127 + 128
     blue  = Math.sin(freq*i + 4*Math::PI/3) * 127 + 128
     "#%02X%02X%02X" % [ red, green, blue ]
  end

  def self.cat(fd, opts={})
    print "\e[?25l" if opts[:animate]
    while true do
      buf = ''
      begin
        begin
          buf += fd.sysread(4096)
          invalid_encoding = !buf.dup.force_encoding(fd.external_encoding).valid_encoding?
        end while invalid_encoding or buf.match(INCOMPLETE_ESCAPE)
      rescue EOFError
        break
      end
      buf.force_encoding(fd.external_encoding)
      buf.lines.each_with_index do |line, i|
        opts[:os] += 1
        line = format('%6d  %s', i + 1, line) if opts[:number]
        println(line, opts)
      end
    end
    ensure
    if STDOUT.tty? then
        print "\e[m\e[?25h\e[?1;5;2004l"
        # system("stty sane -istrip <&1");
    end
  end

  def self.println(str, defaults={}, opts={})
    opts.merge!(defaults)
    chomped = str.sub!(/\n$/, "")
    str.gsub! "\t", "        "
    opts[:animate] ? println_ani(str, opts) : println_plain(str, opts)
    puts if chomped
  end

  private

  def self.println_plain(str, defaults={}, opts={})
    opts.merge!(defaults)
    set_mode(opts[:truecolor])
    str.scan(ANSI_ESCAPE).each_with_index do |c,i|
      color = rainbow(opts[:freq], opts[:os]+i/opts[:spread])
      if opts[:invert] then
        print c[0], Paint.color(nil, color), c[1], "\e[49m"
      else
        print c[0], Paint.color(color), c[1], "\e[39m"
      end
    end
  end

  def self.println_ani(str, opts={})
    return if str.empty?
    print "\e7"
    (1..opts[:duration]).each do |i|
      print "\e8"
      opts[:os] += opts[:spread]
      println_plain(str, opts)
      str.gsub!(/\e\[[0-?]*[@JKPX]/, "")
      sleep 1.0/opts[:speed]
    end
  end

  def self.set_mode(truecolor)
    @paint_mode_detected ||= Paint.mode
    Paint.mode = truecolor ? 0xffffff : @paint_mode_detected
  end
end
