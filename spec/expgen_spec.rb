require "spec_helper"

describe Expgen do
  def self.test(exp, *args)
    it "can generate expressions which match #{exp.source}", *args do
      begin
        20.times { Expgen.gen(exp).should =~ exp }
      rescue Exception => e
        tree = Expgen::Parser::Expression.new.parse(exp.source)
        puts
        puts "exp: " + exp.inspect
        puts "tree: " + tree.inspect
        puts "trans: " + Expgen::Transform.new.apply(tree).inspect
        puts "output: " + Expgen.gen(exp)
        puts
        raise e
      end
    end
  end

  it "raises an exception if the regexp can't be parsed" do
    expect { Expgen.gen(/(?!foo)/) } .to raise_error(Expgen::ParseError)
  end

  test(/foo|bar/)

  describe "groups" do
    test(/(foo)/)
    test(/(foo|bar)/)
    test(/f(oo|ba)r/)
    test(/f(oo|ba){3}r/)
    test(/f(oo|ba){3,6}r/)
    test(/f(oo|ba){3,}r/)
    test(/f(oo|ba)+r/)
    test(/f(oo|ba)*r/)
    test(/f(oo|ba)?r/)
    test(/f(oo|ba|qx|foo)+r/)
    test(/(oo)|(ba)/)
    test(/(o(blah|baz)(o|b))|(ba)/)
  end

  describe "character classes" do
    test(/[abcd]/)
    test(/f[abcd]b/)
    test(/f[a-z]b/)
    test(/f[0-9]b/)
    test(/f[&a-z%]b/)
    test(/f[abcd]b/)
    test(/f[abcd]*b/)
    test(/f[abcd]+b/)
    test(/f[abcd]{2}b/)
    test(/f[abcd]{2,}b/)
    test(/f[abcd]{2,4}b/)
    test(/f[abcd]?b/)
  end

  describe "anchors (are simply ignored)" do
    test(/^foo$/)
    test(/\bfoo\b/)
    test(/f\Bfo/)
    test(/\Afoo\z/)
    test(/\Afoo\Z/)
  end

  describe "shorthand character classes" do
    test(/f\wo/)
    test(/f\w+o/)
    test(/f\w*o/)
    test(/f\w{2}o/)
    test(/f\w{3,}o/)
    test(/f\w{2,4}o/)
    test(/f\w?o/)
    test(/f\Wo/)
    test(/f\do/)
    test(/f\Do/)
    test(/f\ho/)
    test(/f\Ho/)
    test(/f\so/)
    test(/f\So/)
  end

  describe "shorthand character classes inside regular character classes" do
    test(/f[\w]o/)
    test(/f[\w%&]o/)
    test(/f[\w]o/)
  end

  describe "negated character classes" do
    test(/[^abcd]/)
    test(/f[^abcd]b/)
    test(/f[^a-z]b/)
    test(/f[^0-9]b/)
    test(/f[^&a-z%]b/)
    test(/f[^abcd]b/)
    test(/f[^abcd]*b/)
    test(/f[^abcd]+b/)
    test(/f[^abcd]{2}b/)
    test(/f[^abcd]{2,}b/)
    test(/f[^abcd]{2,4}b/)
    test(/f[^\w]o/)
    test(/f[^\w%&]o/)
    test(/f[^\w]o/)
  end

  describe "control characters" do
    test(/f\no/)
    test(/f\so/)
    test(/f\ro/)
    test(/f\to/)
    test(/f\vo/)
    test(/f\fo/)
    test(/f\ao/)
    test(/f\eo/)
    test(/f\345o/)
    test(/f\345123o/)
    test(/f\xAFo/)
    test(/f\xAF12o/)
    test(/f\u04AFo/u)
    test(/f\u04AF00o/u)
    test(/f\qo/)
  end

  describe "control characters in character classes" do
    test(/f[\n]o/)
    test(/f[\s]o/)
    test(/f[\r]o/)
    test(/f[\t]o/)
    test(/f[\v]o/)
    test(/f[\f]o/)
    test(/f[\a]o/)
    test(/f[\e]o/)
    test(/f[\345]o/)
    test(/f[\xAF]o/)
    test(/f[\u04AF]o/u)
    test(/f[\q]o/)
  end

  describe "repeated letters" do
    test(/fo*o/)
    test(/fo+o/)
    test(/fo{2}o/)
    test(/fo{2,}o/)
    test(/fo{2,4}o/)
    test(/fo?o/)
  end

  describe "repeated escape characters" do
    test(/f\n*o/)
    test(/f\n+o/)
    test(/f\n{2}o/)
    test(/f\n{2,5}o/)
    test(/f\n?o/)
    test(/f\345*o/)
    test(/f\345+o/)
    test(/f\345{2}o/)
    test(/f\345{2,}o/)
    test(/f\345{2,4}o/)
    test(/f\345?o/)
    test(/f\xAF*o/)
    test(/f\xAF+o/)
    test(/f\xAF{2}o/)
    test(/f\xAF{2,}o/)
    test(/f\xAF{2,4}o/)
    test(/f\xAF?o/)
    test(/f\u04AF*o/u)
    test(/f\u04AF+o/u)
    test(/f\u04AF{2}o/u)
    test(/f\u04AF{2,}o/u)
    test(/f\u04AF{2,4}o/u)
    test(/f\u04AF?o/u)
    test(/f\q+o/)
    test(/f\q*o/)
    test(/f\q{2}o/)
    test(/f\q{2,}o/)
    test(/f\q{2,4}o/)
    test(/f\q?o/)
  end

  describe "escaped special characters" do
    test(/\//)
    test(/#{Expgen::NON_LITERALS}/)
    test(/}{/)
    test(/\{\}/)
  end

  describe "the wildcard character" do
    test(/f.*o/)
    test(/f.+o/)
    test(/f.{2}o/)
    test(/f.{2,}o/)
    test(/f.{2,4}o/)
    test(/f.?o/)
  end
end
