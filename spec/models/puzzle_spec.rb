require 'spec_helper'

describe Puzzle do
  before(:each) do
    @attr = { 
      :name => "Example Puzzle",
      :description => "Example Puzzle",
      :level => "1",
    }
  end

  it "should create a new instance given a valid attribute" do
    Puzzle.create!(@attr)
  end

  it "should require a name" do
    no_name_puzzle = Puzzle.new(@attr.merge(:name => ""))
    no_name_puzzle.should_not be_valid
  end
  
  it "should require a description" do
    no_desc_puzzle = Puzzle.new(@attr.merge(:description => ""))
    no_desc_puzzle.should_not be_valid
  end
  
  it "should require a level" do
    no_level_puzzle = Puzzle.new(@attr.merge(:level => ""))
    no_level_puzzle.should_not be_valid
  end
  
  it "should reject if level is not in the scope 1..4 (part1)" do
    zero_level_puzzle = Puzzle.new(@attr.merge(:level => "0"))
    zero_level_puzzle.should_not be_valid
  end

  it "should reject if level is not in the scope 1..4 (part2)" do
    five_level_puzzle = Puzzle.new(@attr.merge(:level => "5"))
    five_level_puzzle.should_not be_valid
  end

  it "should reject if level is not in the scope 1..4 (part3)" do
    letter_level_puzzle = Puzzle.new(@attr.merge(:level => "a"))
    letter_level_puzzle.should_not be_valid
  end

end
