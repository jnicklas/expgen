module Expgen
  module Nodes
    class Node
      attr_reader :ast

      def initialize(ast)
        @ast = ast
      end

      def repeat
        ast[:repeat] if ast.is_a?(Hash)
      end
    end

    class Group < Node
      def elements
        ast[:elements]
      end
    end

    class Alternation < Node
      def options
        ast.map { |option| option[:alt] }
      end
    end

    class Character < Node; end

    class CharacterClass < Character
      def groups
        ast[:groups]
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

    class Literal < Character
      def chars
        [ast.to_s]
      end
    end

    class Shorthand < Character
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
    end

    class Range < Character
      def chars
        (ast[:from].to_s..ast[:to].to_s).to_a
      end
    end

    class EscapeChar < Character
      def chars
        [ESCAPE_CHARS[ast.to_s]]
      end
    end

    class CodePointOctal < Character
      def chars
        [ast.to_s.to_i(8).chr]
      end
    end

    class CodePointHex < Character
      def chars
        [ast.to_s.to_i(16).chr]
      end
    end

    class CodePointUnicode < Character
      def chars
        [ast.to_s.to_i(16).chr("UTF-8")]
      end
    end
  end
end
