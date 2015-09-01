require "minitest/autorun"

# Services

class JapaneseSpellChecker
  def check_spelling
  end
end

class EmailBook
  def add_user
  end
end

class SimpleJapaneseTextEditor
  def save_text
  end
end

# Set method injection

class Emailer
  attr_accessor :spell_checker, :address_book, :text_editor
  
  def send_email
    spell_checker.check_spelling if spell_checker
    address_book.add_user if address_book
    text_editor.save_text if text_editor
  end
end

# Factory is responsible for constructing object graph

class EmailerFactory
  def new_japanese_emailer
    service = Emailer.new
    
    service.spell_checker = JapaneseSpellChecker.new
    service.address_book = EmailBook.new
    service.text_editor = SimpleJapaneseTextEditor.new
    
    service
  end
end

# Clients use email without knowing how it got created

emailer = EmailerFactory.new.new_japanese_emailer
emailer.send_email

# Easily testing each dependency

describe Emailer do
  describe "#send_email" do
    it "should check spelling" do
      spell_checker = MiniTest::Mock.new
      spell_checker.expect(:check_spelling, nil)
      
      emailer = Emailer.new
      emailer.spell_checker = spell_checker
      emailer.send_email
      
      spell_checker.verify
    end
  end
end

# How about testing factory client?

class EmailerClient
  attr_reader :emailer
  
  def initialize
    @emailer = EmailerFactory.new.new_japanese_emailer
  end
  
  def run
    emailer.send_email
  end
end

describe EmailerClient do
  it "should send email" do
    emailer = MiniTest::Mock.new
    emailer.expect(:send_email, nil)
    
    emailer_client = EmailerClient.new
    emailer_client.stub :emailer, emailer do
      emailer_client.run
    end
    
    emailer.verify
  end
end

module JavaVersion
  class EmailerMock < Emailer
    attr_reader :send_email_called
  
    def send_email
      @send_email_called = true
    end
  
    def send_email_called?
      send_email_called
    end
  end
  
  class EmailerFactory
    class << self
      attr_accessor :emailer
    end
  
    def new_japanese_emailer
      if self.class.emailer
        self.class.emailer
      else
        service = Emailer.new
    
        service.spell_checker = JapaneseSpellChecker.new
        service.address_book = EmailBook.new
        service.text_editor = SimpleJapaneseTextEditor.new
    
        service
      end
    end
  end
  
  class EmailerClient
    attr_reader :emailer
  
    def initialize
      @emailer = EmailerFactory.new.new_japanese_emailer
    end
  
    def run
      emailer.send_email
    end
  end
  
  describe EmailerClient do
    it "should send email" do
      emailer = EmailerMock.new
      EmailerFactory.emailer = emailer
      
      begin
        emailer_client = EmailerClient.new
        emailer_client.run
    
        assert_equal true, emailer.send_email_called?
      ensure
        EmailerFactory.emailer = nil
      end
    end
  end
end

# Factory itself becomes issue cos of lot's of code duplication in factory methods

class EmailerFactory
  def new_french_emailer
    emailer = Emailer.new
    
    emailer.address_book = EmailBook.new
    # ...
    
    emailer
  end
  
  def new_english_emailer
    emailer = Emailer.new
    
    emailer.address_book = EmailBook.new
    # ...
    
    emailer
  end
  
  # Each time you need new variation of services you need to create another method
end