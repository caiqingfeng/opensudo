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
  validates_inclusion_of :level, :in => 1..4
end
