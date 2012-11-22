require "parslet"
require "expgen/version"
require "expgen/parser"
require "expgen/transform"
require "expgen/randomizer"
require "expgen/character_class"

module Expgen
  def self.cache
    @cache ||= {}
  end

  def self.clear_cache
    @cache = nil
  end

  def self.gen(exp)
    cache[exp.source] ||= Transform.new.apply((Parser.new.parse(exp.source)))
    Randomizer.randomize(cache[exp.source])
  end
end
