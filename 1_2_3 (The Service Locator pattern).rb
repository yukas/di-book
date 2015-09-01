class Application
  def construct
    service = Emailer.new
    service.text_editor = TextEditor.new
    # ...
    
    ServiceLocator.register("JapaneseEmailerWithPhoneAndEmail", service)
  end
  
  def run
    emailer = ServiceLocator.get("JapaneseEmailerWithPhoneAndEmail")
  end
end

