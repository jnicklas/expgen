module Expgen
  LITERALS = "[\^$.|?*+(){}".split("").map { |l| "\\" + l }.join

  class Parser < Parslet::Parser
    rule(:lparen)     { str('(') }
    rule(:rparen)     { str(')') }
    rule(:lcurly)     { str('{') }
    rule(:rcurly)     { str('}') }
    rule(:pipe)       { str('|') }
    rule(:plus)       { str('+') }
    rule(:multiply)   { str('*') }


    rule(:integer)    { match('[0-9]').repeat(1).as(:int) }

    rule(:literal) { match["^#{LITERALS}"].repeat(1) }
    rule(:alternation) { literal.as(:left) >> pipe >> expression.as(:right) }

    rule(:group) do
      lparen >> expression >> rparen >>
      (plus.as(:repeat) | multiply.as(:repeat) | lcurly >> integer.as(:repeat) >> rcurly).maybe
    end

    rule(:expression) { alternation.as(:alternation) | literal.as(:literal) | group.as(:group) }
    rule(:expressions) { expression.repeat }
    root(:expressions)
  end
end
