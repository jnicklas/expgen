require "expgen"

describe Expgen do
  def self.test(exp)
    it "can generate expressions which match #{exp}" do
      20.times { Expgen.gen(exp).should =~ exp }
    end
  end

  test(/foo|bar/)
  test(/(foo|bar)/)
  test(/f(oo|ba)r/)
  test(/f(oo|ba){3}r/)
  test(/f(oo|ba)+r/)
  test(/f(oo|ba)*r/)
end
