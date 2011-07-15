class PuzzlesController < ApplicationController
  # GET /puzzles
  # GET /puzzles.json
  def index
    puzzles_all = Puzzle.all
    @puzzles = puzzles_all.paginate :page => params[:page],:per_page => 5
    @puzzleOnShow = getPuzzleOnShow(@puzzles.first)
    @gridOption = "playable"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @puzzles }
    end
  end

  # GET /puzzles/1
  # GET /puzzles/1.json
  def show
    @puzzle = Puzzle.find(params[:id])
    @puzzleOnShow = getPuzzleOnShow(@puzzle)
    @gridOption = "playable"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @puzzle }
    end
  end

  # GET /puzzles/new
  # GET /puzzles/new.json
  def new
    @puzzle = Puzzle.new
    @puzzleOnShow = getPuzzleOnShow(@puzzle)
    @gridOption = "editable"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @puzzle }
    end
  end

  # GET /puzzles/1/edit
  def edit
    @puzzle = Puzzle.find(params[:id])
    @puzzleOnShow = getPuzzleOnShow(@puzzle)
    @gridOption = "editable"
  end

  # POST /puzzles
  # POST /puzzles.json
  def create
    @puzzle = Puzzle.new(params[:puzzle])
    @puzzleOnShow = getPuzzleOnShow(@puzzle)
    @gridOption = "editable"

    respond_to do |format|
      if @puzzle.save
        format.html { redirect_to @puzzle, notice: 'Puzzle was successfully created.' }
        format.json { render json: @puzzle, status: :created, location: @puzzle }
      else
        format.html { render action: "new" }
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /puzzles/1
  # PUT /puzzles/1.json
  def update
    @puzzle = Puzzle.find(params[:id])
    @puzzleOnShow = getPuzzleOnShow(@puzzle)
    @gridOption = "editable"

    respond_to do |format|
      if @puzzle.update_attributes(params[:puzzle])
        format.html { redirect_to @puzzle, notice: 'Puzzle was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /puzzles/1
  # DELETE /puzzles/1.json
  def destroy
    @puzzle = Puzzle.find(params[:id])
    @puzzle.destroy

    respond_to do |format|
      format.html { redirect_to puzzles_url }
      format.json { head :ok }
    end
  end
  
  def getPuzzleOnShow(puzzle)
  	if !puzzle
  		return "cell11:1,cell23:5,cell99:8"
  	end
  	puzzle.cellstring
  end
end
