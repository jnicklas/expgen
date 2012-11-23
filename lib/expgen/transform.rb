module Expgen
  class Transform < Parslet::Transform
    rule(:literal => simple(:x)) { Nodes::Literal.new(x) }
    rule(:char_class_range => subtree(:x)) { Nodes::Range.new(x) }
    rule(:char_class_literal => simple(:x)) { Nodes::Literal.new(x) }
    rule(:char_class_shorthand => subtree(:x)) { Nodes::Shorthand.new(x) }
    rule(:escape_char => subtree(:x)) { Nodes::EscapeChar.new(x) }
    rule(:char_class => subtree(:x)) { Nodes::CharacterClass.new(x) }
    rule(:code_point_octal => subtree(:x)) { Nodes::CodePointOctal.new(x) }
    rule(:code_point_hex => subtree(:x)) { Nodes::CodePointHex.new(x) }
    rule(:code_point_unicode => subtree(:x)) { Nodes::CodePointUnicode.new(x) }
    rule(:group => subtree(:x)) { Nodes::Group.new(x) }
  end
end
