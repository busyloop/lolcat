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
require "lolcat/lol"

require 'stringio'
require 'trollop'

module Lol
  def self.halp!(text, opts={})
    opts = { 
      :animate => false,
      :duration => 12,
      :os => 0,
      :speed => 20,
      :spread => 8.0,
      :freq => 0.3
    }.merge opts

    begin
      i = 20
      o = rand(256)
      text.split("\n").each do |line|
        i -= 1
        opts[:os] = o+i
        Lol.println line, opts
      end
      puts "\n"
    rescue Interrupt
    end
    exit 1
  end

  def self.cat!
    p = Trollop::Parser.new do
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
      opt :force, "Force color even when stdout is not a tty", :short => 'f', :default => false
      opt :version,  "Print version and exit", :short => 'v'
      opt :help,  "Show this message", :short => 'h'
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

    opts = Trollop::with_standard_exception_handling p do
      begin
        o = p.parse ARGV
      rescue Trollop::HelpNeeded
        buf = StringIO.new
        p.educate buf
        buf.rewind
        halp! buf.read, {}
        buf.close
      end
      o
    end

    p.die :spread, "must be > 0" if opts[:spread] < 0.1
    p.die :duration, "must be > 0" if opts[:duration] < 0.1
    p.die :speed, "must be > 0.1" if opts[:speed] < 0.1

    opts[:os] = opts[:seed]
    opts[:os] = rand(256) if opts[:os] == 0

    begin
      files = ARGV.empty? ? [:stdin] : ARGV[0..-1]
      files.each do |file|
        fd = ARGF if file == '-' or file == :stdin
        begin
          fd = File.open file unless fd == ARGF

          if $stdout.tty? or opts[:force]
            Lol.cat fd, opts
          else
            until fd.eof? do
              $stdout.write(fd.read(8192))
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
        rescue Errno::EPIPE
          exit 1
        end
      end
    rescue Interrupt
    end
  end
end

