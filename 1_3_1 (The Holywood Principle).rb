# The client as such as the service itself are free of any logic
# of how to create or locate dependencies

class Emailer
  def send_email(email_text)
  end
end

class SimpleEmailerClient
  def initialize(emailer)
    @emailer = emailer
  end
  
  def send_email
    emailer.send_email(email_text)
  end
  
  private
  attr_reader :emailer
  
  def email_text
  end
end


class Injector
  def self.construct_emailer_client
    # Infrastructure code ment for wiring and constructing
    
    emailer = Emailer.new
    emailer_client = SimpleEmailerClient.new(emailer)
  end
end