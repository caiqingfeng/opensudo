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
	orgCells = $('#puzzleOnShow', thisObj).text()
	gridOptionText = "playable"
	gridOptionText = $('#gridOption', thisObj).text()
	gridObj = $('#sudokutbl', thisObj)
	gridObj.setGrid(orgCells, orgCells, $.trim(gridOptionText) == "editable")
	#set css for puzzle list
	$('#puzzles_list tr:even').removeClass().addClass("even_tr")
	#AJAX click on puzzle list
	$('#puzzles_list tr').click( ->
		return $(this).updatePuzzleOnShow())
	$('#GreedyMark').click( ->
		orgCells = $('#puzzleOnShow', thisObj).text()
		gridObj.greedyMark(orgCells, $.trim(gridOptionText) == "editable")
		return)
	$('#n_IN_n').click( ->
		orgCells = $('#puzzleOnShow', thisObj).text()
		gridObj.n_IN_n(orgCells, $.trim(gridOptionText) == "editable")
		return)
	$('#Reflection').click( ->
		orgCells = $('#puzzleOnShow', thisObj).text()
		gridObj.reflection(orgCells, $.trim(gridOptionText) == "editable")
		return)
	$('#FindAnswer').click( ->
		orgCells = $('#puzzleOnShow', thisObj).text()
		newCellString = gridObj.genString()
		solvedCellString = gridObj.findAnswer(newCellString)
		alert("It is not a right sudoku!") if solvedCellString == null
		#update grid
		solvedCellString = orgCells if !solvedCellString
		gridObj.setGrid(solvedCellString, orgCells, $.trim(gridOptionText) == "editable")
		return)
	$('#ResetPuzzle').click( ->
		orgCells = $('#puzzleOnShow', thisObj).text()
		gridObj.setGrid(orgCells, orgCells, $.trim(gridOptionText) == "editable")
		return)
	$('#CreateSudo').click( ->
		loc = window.location
		pathName = loc.pathname.substring(0, loc.pathname.lastIndexOf('/') + 1)
		newPath = loc.href.substring(0, loc.href.length - ((loc.pathname + loc.search + loc.hash).length - pathName.length))+"puzzles/new"
		newPath = newPath.replace(/puzzles\/puzzles/g, "puzzles")
		window.location = newPath
		return)
	$('#ListAllSudo').click( ->
		loc = window.location
		pathName = loc.pathname.substring(0, loc.pathname.lastIndexOf('/') + 1)
		listPath = loc.href.substring(0, loc.href.length - ((loc.pathname + loc.search + loc.hash).length - pathName.length))
		listPath = listPath.replace(/\/puzzles(\/|$)/g, "")+"/puzzles"
		listPath = listPath.replace(/\/\/puzzles/g, "/puzzles")
		window.location = listPath
		return)
	$('#Convert-form').dialog({autoOpen: false, modal: true, position: 'top'})
	$('#Convert-form-2').dialog({autoOpen: false, modal: true, position: 'top'})
	$('#TextSudo').click( ->
		$('#Convert-form').dialog("open"))
	$('#Sudo2Text').click( ->
		newCellString = gridObj.genString()
		$('textarea[name="sudoText"]').val(newCellString)
		$('#Convert-form-2').dialog("open"))
	$('#text2Sudo').click( ->
		newCellString = $('textarea[name="textSudo"]').val()
		#alert(newCellString)
		newCellString = gridObj.text2Sudo(newCellString) if !newCellString.match(/cell/i)
		#alert(newCellString)
		if newCellString
			$('#puzzleOnShow', thisObj).text(newCellString)
			gridObj.setGrid(newCellString, newCellString, $.trim(gridOptionText) == "editable")
		$('#Convert-form').dialog("close")
		return false)
	#set hook function of save
	$('#puzzle_form_convas form').submit( ->
		newCellString = gridObj.genString()
		$('input[name="puzzle[cellstring]"]').val(newCellString)
		return true)
		#return gridObj.able2Solve())

$.fn.updatePuzzleOnShow = () ->
	thisObj = $(this)
	#updatePuzzleOnShow = ""
	#AJAX to update grid works, but we can use a better solution without one more call to server
	#$('a', thisObj).each( ->
	#	tmpString = $(this).attr("href")
	#	updatePuzzleOnShow = tmpString.replace(/\/edit$/, ".json") if tmpString.match(/edit$/)
	#	return)
	#if updatePuzzleOnShow != ""
	#	$.get(updatePuzzleOnShow, (data) ->
	#		gridObj = $('#sudokutbl')
	#		gridObj.setGrid(data["cellstring"], false)
	#		return)
	cellString = $('.hiddenField', thisObj).text()
	gridObj = $('#sudokutbl')
	if cellString && cellString != ""
		$('#puzzleOnShow').text(cellString)
		gridObj.setGrid(cellString, cellString, false) 
	return
	
$.fn.able2Solve = () ->
	thisObj = $(this)
	
	#gen string from grid
	cellString = thisObj.genString()
	
	#solved cells
	solvedCellString = thisObj.findAnswer(cellString, 0)
	
	#update grid
	thisObj.setGrid(solvedCellString, "", true)
	
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
		tdNode.removeClass().addClass("cellWithOneNumber")
	return true
	
#only digits allowed and numbers should be different
validateCell = (currentV) ->
	if (currentV.length > 5) or (currentV.match(/[^1-9]{1}/g))
		return false
	stripedString = currentV.replace(/(.).*\1/g, "$1")
	if (stripedString.length != currentV.length)
		return false
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
	
	return true

$.fn.setGrid = (cellString, readOnlyCells, editableGrid) ->
	cellString = "" if !cellString
	sudoCells = $(this).getAllSudoCells()
	sudoCells.each((i, value) ->
		$(value).html("")
		fnCallback = clickOnEdit
		$(value).removeClass().addClass('editableCell')
		patrn = new RegExp(value.id+":[1-9]+", "g")
		matchedCells = cellString.match(patrn)
		if (matchedCells == null || matchedCells.length != 1)
			$(value).unbind("click")
			$(value).editable({onSubmit:fnCallback, editClass: 'cellInput'})
			return
		$(value).html(matchedCells[0].substring(7))
		if !editableGrid && readOnlyCells && readOnlyCells.match(patrn)
			$(value).unbind("click")
			$(value).removeClass().addClass('readOnlyCell')
		else
			$(value).unbind("click")
			$(value).editable({onSubmit:fnCallback, editClass: 'cellInput'})
			if (matchedCells[0].length == 8)
				$(value).removeClass().addClass("cellWithOneNumber")
			if (matchedCells[0].length > 8)
				$(value).removeClass().addClass("cellWithMoreNumbers")
		return true)
	return true

#return array<element>
$.fn.getAllSudoCells = () ->
  thisObj = $(this)
  orgNodes = $('[id^="cell"]', thisObj)
  return orgNodes


