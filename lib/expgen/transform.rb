module Expgen
  class Transform < Parslet::Transform
    rule(:literal => simple(:x)) { x.to_s }
    rule(:char_class_range => subtree(:x)) { CharacterClass::RangeGroup.new(x[:from], x[:to]) }
    rule(:char_class_literal => simple(:x)) { CharacterClass::LiteralGroup.new(x) }
    rule(:char_class_shorthand => subtree(:x)) { CharacterClass::ShorthandGroup.new(x[:letter], x[:repeat]) }
  end
end
