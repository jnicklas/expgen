module Expgen
  module Randomizer
    extend self

    def randomize(tree)
      if tree.is_a?(Array)
        tree.map { |el| randomize(el) }.join
      elsif tree.is_a?(Hash)
        key, value = tree.keys.first, tree.values.first
        case key
        when :alternation then randomize(value[[:left, :right].sample])
        when :literal then randomize(value)
        when :group
          if value[:repeat] == "*"
            ""
          elsif value[:repeat] == "+"
            randomize(value)
          elsif value[:repeat]
            value[:repeat][:int].to_i.times.map { randomize(value) }.join
          else
            randomize(value)
          end
        else raise ArgumentError, "unknown key #{key}"
        end
      else
        tree.to_s
      end
    end
  end
end
