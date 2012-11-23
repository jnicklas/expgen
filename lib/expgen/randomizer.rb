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
      case tree
        when Array              then tree.map { |el| randomize(el) }.join
        when Nodes::Alternation then randomize(tree.options.sample)
        when Nodes::Group       then repeat(tree.repeat) { randomize(tree.elements) }
        when Nodes::Character   then repeat(tree.repeat) { tree.chars.sample }
      end
    end
  end
end
