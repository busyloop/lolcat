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
require "lolcat/lol"

require 'stringio'
require 'optimist'

module Lol
  def self.cat!
    p = Optimist::Parser.new do
      version "lolcat #{Lolcat::VERSION} (c)2011 moe@busyloop.net"
      banner <<HEADER

Usage: lolcat [OPTION]... [FILE]...

Concatenate FILE(s), or standard input, to standard output.
With no FILE, or when FILE is -, read standard input.

HEADER
      banner ''
      opt :spread, "Rainbow spread", :short => 'p', :default => 3.0
      opt :freq, "Rainbow frequency", :short => 'F', :default => 0.1
      opt :seed, "Rainbow seed, 0 = random", :short => 'S', :default => 0
      opt :animate, "Enable psychedelics", :short => 'a', :default => false
      opt :duration, "Animation duration", :short => 'd', :default => 12
      opt :speed, "Animation speed", :short => 's', :default => 20.0
      opt :invert, "Invert fg and bg", :short => 'i', :default => false
      opt :truecolor, "24-bit (truecolor)", :short => 't', :default => false
      opt :force, "Force color even when stdout is not a tty", :short => 'f', :default => false
      opt :version, "Print version and exit", :short => 'v'
      opt :help, "Show this message", :short => 'h'
      banner <<FOOTER

Examples:
  lolcat f - g      Output f's contents, then stdin, then g's contents.
  lolcat            Copy standard input to standard output.
  fortune | lolcat  Display a rainbow cookie.

Report lolcat bugs to <https://github.com/busyloop/lolcat/issues>
lolcat home page: <https://github.com/busyloop/lolcat/>
Report lolcat translation bugs to <http://speaklolcat.com/>

FOOTER
    end

    opts = Optimist::with_standard_exception_handling p do
      begin
        o = p.parse ARGV
      rescue Optimist::HelpNeeded
        buf = StringIO.new
        p.educate buf
        buf.rewind
        opts = {
          :animate => false,
          :duration => 12,
          :os => rand * 8192,
          :speed => 20,
          :spread => 8.0,
          :freq => 0.3
        }
        Lol.cat buf, opts
        puts
        buf.close
        exit 1
      end
      o
    end

    p.die :spread, "must be >= 0.1" if opts[:spread] < 0.1
    p.die :duration, "must be >= 0.1" if opts[:duration] < 0.1
    p.die :speed, "must be >= 0.1" if opts[:speed] < 0.1

    opts[:os] = opts[:seed]
    opts[:os] = rand(256) if opts[:os] == 0

    begin
      files = ARGV.empty? ? [:stdin] : ARGV[0..-1]
      files.each do |file|
        fd = $stdin if file == '-' or file == :stdin
        begin
          fd = File.open(file, "r") unless fd == $stdin

          if $stdout.tty? or opts[:force]
            Lol.cat fd, opts
          else
            if fd.tty?
              fd.each do |line|
                $stdout.write(line)
              end
            else
              IO.copy_stream(fd, $stdout)
            end
          end
        rescue Errno::ENOENT
          puts "lolcat: #{file}: No such file or directory"
          exit 1
        rescue Errno::EACCES
          puts "lolcat: #{file}: Permission denied"
          exit 1
        rescue Errno::EISDIR
          puts "lolcat: #{file}: Is a directory"
          exit 1
        rescue Errno::ENXIO
          puts "lolcat: #{file}: Is not a regular file"
          exit 1
        rescue Errno::EPIPE
          exit 1
        end
      end
    rescue Interrupt
    end
  end
end
