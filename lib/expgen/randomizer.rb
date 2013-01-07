module Expgen
  module Randomizer
    extend self

    def range(number)
      if number == "*"
        [0,5]
      elsif number == "+"
        [1,5]
      elsif number
        [number[:int].to_i, number[:int].to_i]
      else
        [1,1]
      end
    end

    def repeat(number)
      first, last = range(number)
      number = rand(last - first + 1) + first
      number.times.map { yield }.join
    end

    def randomize(tree)
      case tree
        when Array              then tree.map { |el| randomize(el) }.join
        when Nodes::Alternation then randomize(tree.options.sample)
        when Nodes::Group       then repeat(tree.repeat) { randomize(tree.elements) }
        when Nodes::Character   then repeat(tree.repeat) { tree.chars.sample }
      end
    end
  end
end
