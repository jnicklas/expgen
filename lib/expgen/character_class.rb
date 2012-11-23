module Expgen
  class CharacterClass < Struct.new(:ast)
    ASCII = (32.chr..126.chr).to_a
    WORD = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a + ["_"]
    NEGATIVE_WORD = ASCII - WORD
    DIGIT = (0..9).map(&:to_s)
    NON_DIGIT = ASCII - DIGIT
    HEX_DIGIT = ("a".."f").to_a + ("A".."F").to_a + ("0".."9").to_a
    NON_HEX_DIGIT = ASCII - HEX_DIGIT
    SPACE = [" "]
    NON_SPACE = ASCII.drop(1)

    class LiteralGroup < Struct.new(:ast)
      def chars
        [ast.to_s]
      end
    end

    class ShorthandGroup < Struct.new(:ast)
      def chars
        case ast[:letter].to_s
          when "w" then WORD
          when "W" then NEGATIVE_WORD
          when "d" then DIGIT
          when "D" then NON_DIGIT
          when "h" then HEX_DIGIT
          when "H" then NON_HEX_DIGIT
          when "s" then SPACE
          when "S" then NON_SPACE
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

    class EscapeCharGroup < Struct.new(:ast)
      ESCAPE_CHARS = { "n" => "\n", "s" => "\s", "r" => "\r", "t" => "\t", "v" => "\v", "f" => "\f", "a" => "\a", "e" => "\e" }
      def chars
        [ESCAPE_CHARS[ast.to_s]]
      end
    end

    def groups
      ast[:groups]
    end

    def repeat
      ast[:repeat]
    end

    def chars
      chars = groups.map(&:chars).flatten
      val = if ast[:negative]
        ASCII - chars
      else
        chars
      end
    end
  end
end
