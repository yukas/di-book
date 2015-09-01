require "minitest/autorun"

class SpellChecker
  def check_spelling
  end
end

class Emailer
  attr_accessor :spell_checker

  def send_email
    spell_checker.check_spelling
  end
end

describe Emailer do
  it "should send email" do
    spell_checker = MiniTest::Mock.new
    spell_checker.expect(:check_spelling, nil)
    
    emailer = Emailer.new
    emailer.spell_checker = spell_checker
    emailer.send_email
    
    spell_checker.verify
  end
end


module ConstructorInjection
  class FrenchSpellChecker < SpellChecker
  end

  class Emailer
    attr_reader :spell_checker
  
    def initialize(spell_checker)
      @spell_checker = spell_checker
    end
    
    def send_email
      spell_checker.check_spelling
    end
  end

  emailer = Emailer.new(FrenchSpellChecker.new)
  emailer.send_email
end

# Duplication
# Violates encapsulation