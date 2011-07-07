# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require sudokus

$ = jQuery

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

options = {editableCallback: clickOnEdit, playable: false, editable: true}

#div sudokus_container, div sudokustbl are global shared 
#create table by the parameter cellString
#set readOnly cells by readOnly parameter
#new puzzle or play puzzle (show puzzle)

$(document).ready -> 
	thisObj = $(this)
	thisObj.initGrid()
	cellString = $('#puzzleOnShow', thisObj).text()
	gridObj = $('#sudokutbl', thisObj)
	gridObj.setGrid(cellString)

#sudoku(options)

$.fn.updateFormCellString = (cellId, cellV) ->
	return false if cellV.length != 1
	thisObj = $(this)
	cellStringField = $('input[id$="cellstring"]', thisObj)
	orgCellString = cellStringField.val()
	patrn = new RegExp(cellId+":[1-9]*")
	patrn.global = true
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
		#createRowString = "<tr></tr>"
		gridObj.append(createRowString)
		rowX = $('#'+rowXString, gridObj)
		for y in [1..9]
			cellXYString = 'cell' + x + y
			createCellString = "<td id='" + cellXYString + "'></td>"
			#createCellString = "<td></td>"
			rowX.append(createCellString)
			cellXY = $('#'+cellXYString, rowX)
	
	convas.append('<h5><a rel="classic" class="styleswitch" style="cursor:pointer;">Classic</a> | <a rel="green_style" class="styleswitch" style="cursor:pointer;">Green</a> </h5>')
	
	return true

$.fn.setGrid = (cellString) ->
	cellString = "" if !cellString
	cssName = "standard"
	allCells = genCells(cellString)
	sudoCells = $(this).getAllSudoCells()
	sudoCells.each((i, value) ->
		$(value).removeClass().addClass('editableCell')
		patrn = new RegExp(value.id+":[1-9]*")
		patrn.global = true
		matchedCells = cellString.match(patrn)
		if (matchedCells == null) or (matchedCells.length != 1)
			$(value).unbind("click")
			$(value).editable({onSubmit:clickOnEdit, editClass: 'cellInput'})
			return
		$(value).removeClass().addClass('readOnlyCell')
		$(value).html(matchedCells[0].substring(7))
		return true)
	return true

#return array<element>
$.fn.getAllSudoCells = () ->
  thisObj = $(this)
  orgNodes = $('[id^="cell"]', thisObj)
  return orgNodes


