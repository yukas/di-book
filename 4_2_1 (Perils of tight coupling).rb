class Emailer
  attr_reader :spell_checker
  
  def initialize
    @spell_checker = EnglishSpellChecker.new
  end
end