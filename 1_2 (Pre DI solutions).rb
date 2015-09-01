require "minitest/autorun"

class SpellChecker
  def check_spelling
    true
  end
end

class Emailer
  attr_accessor :spell_checker
  
  def initialize
    self.spell_checker = SpellChecker.new
  end
  
  def send_email
    spell_checker.check_spelling
  end
end

describe Emailer do
  describe "#send_email" do
    it "should send email" do
      spell_checker = MiniTest::Mock.new
      spell_checker.expect(:check_spelling, nil)
    
      emailer = Emailer.new
    
      emailer.stub :spell_checker, spell_checker do
        emailer.send_email
      end
    
      spell_checker.verify
    end
  end
end

class MockSpellChecker < SpellChecker
  attr_reader :check_spelling_called
  
  def check_spelling
    @check_spelling_called = true
  end
  
  def verify_check_spelling_called
    check_spelling_called
  end
end

describe Emailer do
  describe "#send_email" do
    it "should send email" do
      spell_checker = MockSpellChecker.new
    
      emailer = Emailer.new
    
      emailer.stub :spell_checker, spell_checker do
        emailer.send_email
      end
    
      assert_equal true, spell_checker.verify_check_spelling_called
    end
  end
end