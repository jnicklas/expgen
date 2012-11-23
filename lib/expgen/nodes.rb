module Expgen
  module Nodes
    class CharacterClass < Struct.new(:ast)
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

    class Literal < Struct.new(:ast)
      def chars
        [ast.to_s]
      end
    end

    class Shorthand < Struct.new(:ast)
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

    class Range < Struct.new(:ast)
      def chars
        (ast[:from].to_s..ast[:to].to_s).to_a
      end
    end

    class EscapeChar < Struct.new(:ast)
      def chars
        [ESCAPE_CHARS[ast.to_s]]
      end
    end

    class CodePointOctal < Struct.new(:ast)
      def chars
        [ast.to_s.to_i(8).chr]
      end
    end

    class CodePointHex < Struct.new(:ast)
      def chars
        [ast.to_s.to_i(16).chr]
      end
    end

    class CodePointUnicode < Struct.new(:ast)
      def chars
        [ast.to_s.to_i(16).chr("UTF-8")]
      end
    end
  end
end
