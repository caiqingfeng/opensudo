# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require sudokus

$ = jQuery

#div sudokus_container, div sudokustbl are global shared 
#create table by the parameter cellString
#set readOnly cells by readOnly parameter
#new puzzle or play puzzle (show puzzle)

$(document).ready -> 
	thisObj = $(this)
	thisObj.initGrid()
	cellString = $('#puzzleOnShow', thisObj).text()
	gridOptionText = "playable"
	gridOptionText = $('#gridOption', thisObj).text()
	gridObj = $('#sudokutbl', thisObj)
	gridObj.setGrid(cellString, $.trim(gridOptionText) == "editable")
	#set css for puzzle list
	$('#puzzles_list tr:even').removeClass().addClass("even_tr")
	#AJAX click on puzzle list
	$('#puzzles_list tr').click( ->
		return $(this).updatePuzzleOnShow())
	#set hook function of save
	$('#puzzle_form_convas form').submit( ->
		return gridObj.able2Solve())

$.fn.updatePuzzleOnShow = () ->
	thisObj = $(this)
	updatePuzzleOnShow = ""
	$('a', thisObj).each( ->
		tmpString = $(this).attr("href")
		updatePuzzleOnShow = tmpString.replace(/\/edit$/, ".json") if tmpString.match(/edit$/)
		#alert(updatePuzzleOnShow)
		return)
	if updatePuzzleOnShow != ""
		$.get(updatePuzzleOnShow, (data) ->
			gridObj = $('#sudokutbl')
			gridObj.setGrid(data["cellstring"], false)
			return)
	return
	
$.fn.able2Solve = () ->
	thisObj = $(this)
	
	#gen string from grid
	cellString = thisObj.genString()
	
	#solved cells
	solvedCellString = thisObj.findAnswer(cellString, 0)
	
	#update grid
	thisObj.setGrid(solvedCellString, true)
	
	#verify cells solved
	able2Solved = thisObj.completedGrid(solvedCellString)
	if !able2Solved
		alert("Are you sure is it a valid grid?")
		return false
	return true

$.fn.genString = () ->
	thisObj = $(this)
	cellString = ""
	sudoCells = $(this).getAllSudoCells()
	sudoCells.each((i, value) ->
		cellString = cellString + "," + value.id + ":" + $(value).html())
	return cellString
	
#cannot DRY here because it's callback. $(this) need to be in the stack 1
clickOnPlay = (content) ->
	$sudo = $('#sudokutbl')
	tdNode = $(this)
	cellId =  tdNode[0].id.substring(4, 6)
	cellValidate = validateCell(content.current)
	if (cellValidate == false)
		tdNode.html("")
		alert("You have to enter a very different digit 1..9.")
		return false
	if (content.current.length > 1)
		tdNode.removeClass().addClass("cellWithMoreNumbers")
	else
		tdNode.removeClass().addClass("editableCell")
	return true

#canot DRY here ... means cannot just call clickOnPlay instead of copying the code from it
clickOnEdit = (content) ->
	$sudo = $('#sudokutbl')
	tdNode = $(this)
	cellId =  tdNode[0].id.substring(4, 6)
	cellValidate = validateCell(content.current)
	if (cellValidate == false)
		tdNode.html("")
		alert("You have to enter a very different digit 1..9.")
		return false
	if (content.current.length > 1)
		tdNode.removeClass().addClass("cellWithMoreNumbers")
	else
		tdNode.removeClass().addClass("editableCell")
	if (content.current.length == 1)
		$(document).updateFormCellString("cell"+cellId, content.current)
	return true
	
#only digits allowed and numbers should be different
validateCell = (currentV) ->
	if (currentV.length > 5) or (currentV.match(/[^1-9]{1}/g))
		return false
	stripedString = currentV.replace(/(.).*\1/g, "$1")
	if (stripedString.length != currentV.length)
		return false
	return true

#sudoku(options)

$.fn.updateFormCellString = (cellId, cellV) ->
	return false if cellV.length != 1
	thisObj = $(this)
	cellStringField = $('input[id$="cellstring"]', thisObj)
	orgCellString = cellStringField.val()
	patrn = new RegExp(cellId+":[1-9]*", "g")
	#patrn.global = true
	if orgCellString.match(patrn)
		cellString = orgCellString.replace(patrn, cellId+":"+cellV)
	else
		cellString = orgCellString+cellId+":"+cellV
	cellStringField.val(cellString)
	return true
	
$.fn.initGrid = () ->
	thisObj = $(this)
	convas = $('#sudokutbl_convas', thisObj)
	convas.empty()
	convas.append('<table id="sudokutbl"></table>')
	#take me a few days to fix it when $('sudokutbl') doesn't work
	gridObj = $('#sudokutbl', convas)
	for x in [1..9]
		rowXString = 'row' + x
		createRowString = "<tr id='" + rowXString + "'></tr>"
		gridObj.append(createRowString)
		rowX = $('#'+rowXString, gridObj)
		for y in [1..9]
			cellXYString = 'cell' + x + y
			createCellString = "<td id='" + cellXYString + "'></td>"
			rowX.append(createCellString)
			cellXY = $('#'+cellXYString, rowX)
	
	return true

$.fn.setGrid = (cellString, editableGrid) ->
	cellString = "" if !cellString
	sudoCells = $(this).getAllSudoCells()
	sudoCells.each((i, value) ->
		$(value).html("")
		fnCallback = clickOnPlay
		fnCallback = clickOnEdit if editableGrid
		$(value).removeClass().addClass('editableCell')
		patrn = new RegExp(value.id+":[1-9]+", "g")
		matchedCells = cellString.match(patrn)
		if (matchedCells == null || matchedCells.length != 1)
			$(value).unbind("click")
			$(value).editable({onSubmit:fnCallback, editClass: 'cellInput'})
			return
		$(value).html(matchedCells[0].substring(7))
		if !editableGrid
			$(value).unbind("click")
			$(value).removeClass().addClass('readOnlyCell')
		else
			$(value).unbind("click")
			$(value).editable({onSubmit:fnCallback, editClass: 'cellInput'})
			if (matchedCells[0].length > 8)
				$(value).addClass("cellWithMoreNumbers")
		return true)
	return true

#return array<element>
$.fn.getAllSudoCells = () ->
  thisObj = $(this)
  orgNodes = $('[id^="cell"]', thisObj)
  return orgNodes


