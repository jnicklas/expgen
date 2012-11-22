module Expgen
  class CharacterClass
    class LiteralGroup < Struct.new(:letter)
      def chars
        [letter.to_s]
      end
    end

    class ShorthandGroup < Struct.new(:letter)
      def chars
        case letter.to_s
          when "w" then ("a".."z").to_a.sample        # A word character ([a-zA-Z0-9_])
          when "W" then "!@$%^&*()".split("").sample  # A non-word character ([^a-zA-Z0-9_])
          when "d" then rand(10).to_s                 # A digit character ([0-9])
          when "D" then ("a".."z").to_a.sample        # A non-digit character ([^0-9])
          when "h" then rand(16).to_s(16)             # A hexdigit character ([0-9a-fA-F])
          when "H" then ("g".."z").to_a.sample        # A non-hexdigit character ([^0-9a-fA-F])
          when "s" then " "                           # A whitespace character: /[ \t\r\n\f]/
          when "S" then ("a".."z").to_a.sample        # A non-whitespace character: /[^ \t\r\n\f]/
        end
      end
    end

    class RangeGroup < Struct.new(:from, :to)
      def chars
        (from.to_s..to.to_s).to_a
      end
    end

    def negated?
    end

  end
end
