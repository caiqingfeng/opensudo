require 'spec_helper'

describe Puzzle do
  before(:each) do
    @attr = { 
      :name => "Example Puzzle",
      :description => "Example Puzzle",
      :cellstring => "cell11:1,cell12:3,cell13:4",
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

  it "should require a cellstring" do
    no_cellstring_puzzle = Puzzle.new(@attr.merge(:level => ""))
    no_cellstring_puzzle.should_not be_valid
  end

  it "should reject if cellstring is empty" do
    empty_cellstring_puzzle = Puzzle.new(@attr.merge(:cellstring => ""))
    empty_cellstring_puzzle.should_not be_valid
  end

  it "should reject if one cell assigned value twice" do
    one_cell_twice_puzzle = Puzzle.new(@attr.merge(:cellstring => "cell11:1,cell11:2"))
    one_cell_twice_puzzle.should_not be_valid
  end

  it "should reject if cell's value is not in the range [1..9] part 1" do
    cell_value_not_1_9_puzzle = Puzzle.new(@attr.merge(:cellstring => "cell11:a,cell19:1"))
    cell_value_not_1_9_puzzle.should_not be_valid
  end
  
  it "should reject if cell's value is not in the range [1..9] part 2" do
    cell_value_not_1_9_puzzle = Puzzle.new(@attr.merge(:cellstring => "cell11:0,cell19:1"))
    cell_value_not_1_9_puzzle.should_not be_valid
  end
  
  it "should reject if cell's value is not in the range [1..9] part 3" do
    cell_value_not_1_9_puzzle = Puzzle.new(@attr.merge(:cellstring => "cell11:,cell19:1"))
    cell_value_not_1_9_puzzle.should_not be_valid
  end
  
  it "should reject if cellstring is line conflict" do
    conflict_line_puzzle = Puzzle.new(@attr.merge(:cellstring => "cell11:1,cell19:1"))
    conflict_line_puzzle.should_not be_valid
  end
  
  it "should reject if cellstring is row conflict" do
    conflict_row_puzzle = Puzzle.new(@attr.merge(:cellstring => "cell11:1,cell19:3,cell21:1"))
    conflict_row_puzzle.should_not be_valid
  end
  
  it "should reject if cellstring is grid conflict (part 1)" do
    conflict_grid_puzzle = Puzzle.new(@attr.merge(:cellstring => "cell11:1,cell19:3,cell33:1"))
    conflict_grid_puzzle.should_not be_valid
  end
  
  it "should reject if cellstring is grid conflict (part 2)" do
    conflict_grid_puzzle = Puzzle.new(@attr.merge(:cellstring => "cell11:1,cell19:3,cell33:4,cell88:9,cell97:9"))
    conflict_grid_puzzle.should_not be_valid
  end
  
end
