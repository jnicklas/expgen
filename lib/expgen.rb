require "parslet"
require "expgen/version"
require "expgen/parser"
require "expgen/randomizer"

module Expgen
  def self.gen(exp)
    Randomizer.randomize(Parser.new.parse(exp.source))
  end
end
