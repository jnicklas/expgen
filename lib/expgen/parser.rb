module Expgen
  NON_LITERALS = "[]\^$.|?*+(){}".split("").map { |l| "\\" + l }.join

  class Parser < Parslet::Parser
    rule(:lparen)     { str('(') }
    rule(:rparen)     { str(')') }
    rule(:lbracket)   { str('[') }
    rule(:rbracket)   { str(']') }
    rule(:lcurly)     { str('{') }
    rule(:rcurly)     { str('}') }
    rule(:pipe)       { str('|') }
    rule(:plus)       { str('+') }
    rule(:multiply)   { str('*') }
    rule(:dash)       { str('-') }
    rule(:comma)      { str(',') }
    rule(:backslash)  { str('\\') }

    rule(:integer)    { match('[0-9]').repeat(1).as(:int) }

    rule(:literal) { match["^#{NON_LITERALS}"] }

    rule(:repeat_amount) { lcurly >> integer.as(:repeat) >> (comma >> integer.as(:max).maybe).maybe >> rcurly }
    rule(:repeat) { plus.as(:repeat) | multiply.as(:repeat) | repeat_amount }

    #groups
    rule(:group) do
      lparen >> expression.as(:content) >> rparen >> repeat.maybe
    end

    # character classes
    rule(:alpha) { match["a-z"] }
    rule(:number) { match["0-9"] }
    rule(:char) { match["^#{NON_LITERALS}"] }
    rule(:range) { (alpha.as(:from) >> dash >> alpha.as(:to)) | (number.as(:from) >> dash >> number.as(:to)) }
    rule(:char_class) do
      lbracket >> ( char_class_shorthand.as(:char_class_shorthand) | range.as(:char_class_range) | char.as(:char_class_literal)).repeat.as(:groups) >> rbracket >> repeat.maybe
    end
    rule(:char_class_shorthand) { backslash >> match["wWdDhHsS"].as(:letter) >> repeat.maybe }

    # basics
    rule(:thing) { anchor | char_class_shorthand.as(:char_class_shorthand) | literal.as(:literal) | group.as(:group) | char_class.as(:char_class) }
    rule(:things) { thing.repeat(1) }

    rule(:anchor) { str("^") | str("$") | backslash >> match["bBAzZ"] }

    rule(:alternation) { things.as(:alt) >> (pipe >> things.as(:alt)).repeat(1) }

    rule(:expression) { alternation.as(:alternation) | things }
    root(:expression)
  end
end
