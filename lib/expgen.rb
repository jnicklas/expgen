require "parslet"
require "expgen/version"
require "expgen/parser"
require "expgen/transform"
require "expgen/randomizer"

module Expgen
  def self.gen(exp)
    Randomizer.randomize(Transform.new.apply((Parser.new.parse(exp.source))))
  end
end
