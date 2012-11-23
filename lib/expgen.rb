require "parslet"
require "expgen/version"
require "expgen/parser"
require "expgen/transform"
require "expgen/randomizer"
require "expgen/nodes"

module Expgen
  ASCII = (32.chr..126.chr).to_a
  WORD = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a + ["_"]
  NEGATIVE_WORD = ASCII - WORD
  DIGIT = (0..9).map(&:to_s)
  NON_DIGIT = ASCII - DIGIT
  HEX_DIGIT = ("a".."f").to_a + ("A".."F").to_a + ("0".."9").to_a
  NON_HEX_DIGIT = ASCII - HEX_DIGIT
  SPACE = [" "]
  NON_SPACE = ASCII.drop(1)

  ESCAPE_CHARS = { "n" => "\n", "s" => "\s", "r" => "\r", "t" => "\t", "v" => "\v", "f" => "\f", "a" => "\a", "e" => "\e" }

  class ParseError < StandardError; end

  def self.cache
    @cache ||= {}
  end

  def self.clear_cache
    @cache = nil
  end

  def self.gen(exp)
    cache[exp.source] ||= Transform.new.apply((Parser.new.parse(exp.source)))
    Randomizer.randomize(cache[exp.source])
  rescue Parslet::ParseFailed => e
    raise Expgen::ParseError, e.message
  end
end
