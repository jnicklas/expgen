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
        when :char_class
          repeat(value[:repeat]) { value[:content].map(&:chars).flatten.sample }
        when :code_point_octal
          value.to_s.to_i(8).chr
        when :code_point_hex
          value.to_s.to_i(16).chr
        when :code_point_unicode
          value.to_s.to_i(16).chr("UTF-8")
        else raise ArgumentError, "unknown key #{key}"
        end
      elsif tree.is_a?(CharacterClass)
        repeat(tree.repeat) { tree.chars.sample }
      elsif tree.is_a?(CharacterClass::ShorthandGroup)
        repeat(tree.repeat) { tree.chars.sample }
      elsif tree.is_a?(CharacterClass::EscapeCharGroup)
        tree.chars.sample
      else
        tree.to_s
      end
    end

    def shorthand(letter)
      CharacterClass::ShorthandGroup.new(letter).chars
    end
  end
end
