class StringSearch
  def starts_with(list, sample)
    list.each do |str|
      return str if str.start_with?(sample)
    end
  end
  
  def contains(list, sample)
    list.each do |str|
      return str if str =~ /sample/
    end
  end
end