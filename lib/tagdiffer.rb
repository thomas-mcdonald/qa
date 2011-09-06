class TagDiffer
  def self.diff(new, old)
    @result = []
    @new = new.split(",")
    @old = old.split(",")
    @new.each do |tag|
      htag = { :tag => tag }
      htag[:insert] = true unless @old.include? tag
      @result << htag
    end
    @old.each do |tag|
      htag = { :tag => tag, :remove => true }
      @result << htag unless @new.include? tag
    end
    @result
  end
end

