module Expgen
  class Transform < Parslet::Transform
    rule(:literal => simple(:x)) { x.to_s }
    rule(:char_class_range => subtree(:x)) { CharacterClass::RangeGroup.new(x) }
    rule(:char_class_literal => simple(:x)) { CharacterClass::LiteralGroup.new(x) }
    rule(:char_class_shorthand => subtree(:x)) { CharacterClass::ShorthandGroup.new(x) }
    rule(:char_class => subtree(:x)) { CharacterClass.new(x) }
  end
end
