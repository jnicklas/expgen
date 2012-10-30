module Expgen
  class Transform < Parslet::Transform
    rule(:literal => simple(:x)) { x.to_s }
    rule(:char => simple(:x)) { x.to_s }
    rule(:range => subtree(:x)) { ((x[:from].to_s)..(x[:to].to_s)).to_a }
  end
end
