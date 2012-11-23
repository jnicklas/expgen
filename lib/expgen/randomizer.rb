module Expgen
  module Randomizer
    extend self

    def repeat(number)
      if number == "*"
        ""
      elsif number == "+"
        yield
      elsif number
        number[:int].to_i.times.map { yield }.join
      else
        yield
      end
    end

    def randomize(tree)
      if tree.is_a?(Array)
        tree.map { |el| randomize(el) }.join
      elsif tree.is_a?(Hash)
        key, value = tree.keys.first, tree.values.first
        case key
        when :alternation then randomize(value.sample[:alt])
        when :group
          repeat(value[:repeat]) { randomize(value[:content]) }
        else raise ArgumentError, "unknown key #{key}"
        end
      elsif tree.is_a?(Nodes::Character)
        repeat(tree.repeat) { tree.chars.sample }
      else
        tree.to_s
      end
    end
  end
end
