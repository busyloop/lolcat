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

require 'optparse'

module Lol
  def self.cat!
    if ['-h','--help','--halp','--version'].include? ARGV[0] 
      begin
        puts
        Lol.whut "Usage: lolcat [[file] [[file] [[file] [[file] [file]]]] [...]]", 20
        puts
        Lol.whut "Concatenate FILE(s), or standard input, to standard output.", 19
        Lol.whut "With no FILE, or when FILE is -, read standard input.", 18
        puts
        Lol.whut "  -h, --help, --halp, --version   display this help and exit", 17
    
        puts
        Lol.whut "Examples:"
        Lol.whut "  lolcat f - g      Output f's contents, then standard input, then g's contents.", 16
        Lol.whut "  lolcat            Copy standard input to standard output.", 15
        Lol.whut "  fortune | lolcat  Display a rainbow cookie.", 14
    
        puts
        Lol.whut "Report lolcat bugs to <http://www.github.org/busyloop/lolcat/issues>", 13
        Lol.whut "lolcat home page: <http://www.github.org/busyloop/lolcat/>", 12
        Lol.whut "Report lolcat translation bugs to <http://speaklolcat.com/>", 11
        Lol.whut "For complete documentation, read the source!", 10
        puts
      rescue Interrupt
      end
      exit 1
    end
    
    begin
      fds = ARGV.empty? ? [ARGF] : ARGV[0..-1]
      fds.each do |file|
        file = ARGF if file == '-'
        file = File.open file unless file == ARGF
        Lol.cat file,8 
      end
    rescue Interrupt
    end
  end
end

