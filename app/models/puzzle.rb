class Puzzle
  include Mongoid::Document
  field :level, :type => Integer
  field :name, :type => String
  field :cellstring, :type => String
  field :description, :type => String
  field :createon, :type => Time, :default => Time.now
  
  embeds_many :sudokus
  
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :level
  validates_presence_of :cellstring
  validates_inclusion_of :level, :in => 1..4
  
  validate :validate_sudoku?
  
  def validate_sudoku? 
  	#numericality
    1.upto(9) do |x|
      1.upto(9) do |y|
        #if cellxy found, should be cellxy:[1-9]
        pattrn = Regexp.new("cell"+x.to_s+y.to_s)
        if self.cellstring =~ pattrn
          errors.add(:cellstring, "one cell assigned value once") if self.cellstring.scan(pattrn).length != 1
          pattrn = Regexp.new("cell"+x.to_s+y.to_s+":[1-9]{1}")
          errors.add(:cellstring, "only [1..9] allowed for sudoku") if !(self.cellstring =~ pattrn)
        end
      end
    end
    
    #line by line
    1.upto(9) do |v|
	  1.upto(9) do |x|
        pattrn = Regexp.new("cell"+x.to_s+"[1-9]{1}:"+v.to_s)
        v_times = self.cellstring.scan(pattrn).length
        errors.add(:cellstring, "1..9 only appear once in one line") if (v_times > 0 && v_times != 1)
      end
    end
    
    #row by row
    1.upto(9) do |v|
      1.upto(9) do |y|
        pattrn = Regexp.new("cell"+"[1-9]{1}"+y.to_s+":"+v.to_s)
        v_times = self.cellstring.scan(pattrn).length
        errors.add(:cellstring, "1..9 only appear once in one row") if (v_times > 0 && v_times != 1)
      end
    end
    
    #small grid by grid
    1.upto(9) do |v|
      #grid 11-12-13-21-22-23-31-32-33
      pattrn = Regexp.new("cell"+"(11|12|13|21|22|23|31|32|33)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
      #grid 14-...-36
      pattrn = Regexp.new("cell"+"(14|15|16|24|25|26|34|35|36)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
      #grid 17-...-39
      pattrn = Regexp.new("cell"+"(17|18|19|27|28|29|37|38|39)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
      
      #grid 41-42-43-51-52-53-61-62-63
      pattrn = Regexp.new("cell"+"(41|42|43|51|52|53|61|62|63)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
      #grid 44-...-66
      pattrn = Regexp.new("cell"+"(44|45|46|54|55|56|64|65|66)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
      #grid 47-...-69
      pattrn = Regexp.new("cell"+"(47|48|49|57|58|59|67|68|69)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
      
      #grid 71-72-73-81-82-83-91-92-93
      pattrn = Regexp.new("cell"+"(71|72|73|81|82|83|91|92|93)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
      #grid 74-...-96
      pattrn = Regexp.new("cell"+"(74|75|76|84|85|86|94|95|96)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
      #grid 77-...-99
      pattrn = Regexp.new("cell"+"(77|78|79|87|88|89|97|98|99)"+":"+v.to_s)
      v_times = self.cellstring.scan(pattrn).length
      errors.add(:cellstring, "1..9 only appear once in one grid") if (v_times > 0 && v_times != 1)
    end
  	
  	return true
  end
end
