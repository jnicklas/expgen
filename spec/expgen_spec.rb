require "spec_helper"

describe Expgen do
  def self.test(exp, *args)
    it "can generate expressions which match #{exp.source}", *args do
      begin
        20.times { Expgen.gen(exp).should =~ exp }
      rescue Exception => e
        puts
        puts "exp: " + exp.inspect
        puts "tree: " + Expgen::Parser.new.parse(exp.source).inspect
        puts "trans: " + Expgen::Transform.new.apply(Expgen::Parser.new.parse(exp.source)).inspect
        puts "output: " + Expgen.gen(exp)
        puts
        raise e
      end
    end
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
  end
end
