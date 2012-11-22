module Expgen
  class CharacterClass < Struct.new(:ast)
    class LiteralGroup < Struct.new(:ast)
      def chars
        [ast.to_s]
      end
    end

    class ShorthandGroup < Struct.new(:ast)
      def chars
        case ast[:letter].to_s
          when "w" then ("a".."z").to_a                # A word character ([a-zA-Z0-9_])
          when "W" then "!@$%^&*()".split("")          # A non-word character ([^a-zA-Z0-9_])
          when "d" then (0..9).map(&:to_s)             # A digit character ([0-9])
          when "D" then ("a".."z").to_a                # A non-digit character ([^0-9])
          when "h" then (0..15).map { |n| n.to_s(16) } # A non-hexdigit character ([^0-9a-fA-F])
          when "H" then ("g".."z").to_a                # A non-whitespace character: /[^ \t\r\n\f]/
          when "s" then [" "]                          # A whitespace character: /[ \t\r\n\f]/
          when "S" then ("a".."z").to_a                # A non-whitespace character: /[^ \t\r\n\f]/
        end
      end

      def repeat
        ast[:repeat]
      end
    end

    class RangeGroup < Struct.new(:ast)
      def chars
        (ast[:from].to_s..ast[:to].to_s).to_a
      end
    end

    def groups
      ast[:groups]
    end

    def repeat
      ast[:repeat]
    end

    def chars
      groups.map(&:chars).flatten
    end
  end
end
