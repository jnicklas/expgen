module Expgen
  class Transform < Parslet::Transform
    rule(:literal => simple(:x)) { CharacterClass::LiteralGroup.new(x) }
    rule(:char_class_range => subtree(:x)) { CharacterClass::RangeGroup.new(x) }
    rule(:char_class_literal => simple(:x)) { CharacterClass::LiteralGroup.new(x) }
    rule(:char_class_shorthand => subtree(:x)) { CharacterClass::ShorthandGroup.new(x) }
    rule(:escape_char => subtree(:x)) { CharacterClass::EscapeCharGroup.new(x) }
    rule(:char_class => subtree(:x)) { CharacterClass.new(x) }
    rule(:code_point_octal => subtree(:x)) { CharacterClass::CodePointOctal.new(x) }
    rule(:code_point_hex => subtree(:x)) { CharacterClass::CodePointHex.new(x) }
    rule(:code_point_unicode => subtree(:x)) { CharacterClass::CodePointUnicode.new(x) }
  end
end
