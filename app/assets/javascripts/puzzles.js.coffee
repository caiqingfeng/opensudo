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
		#don't know why class in puzzle.css.scss can't define font size there, so have to do it here.
		tdNode.css("font-size", "13px")
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
	cellString = $('#puzzle_cellstring', thisObj).val()
	gridObj = $('#sudokutbl', thisObj)
	gridObj.setGrid(cellString)

#sudoku(options)

$.fn.setGrid = (cellString) ->
	alert(cellString)
	cssName = "standard"
	allCells = genCells(cellString)
	sudoCells = $(this).getAllSudoCells()
	sudoCells.each((i, value) ->
		$(value).removeClass().addClass('readOnlyCell')
		patrn = new RegExp(value.id+":[1-9]*")
		patrn.global = true
		matchedCells = cellString.match(patrn)
		if (matchedCells == null) or (matchedCells.length != 1)
			$(value).unbind("click")
			$(value).editable({onSubmit:clickOnEdit, editClass: 'editableCell'})
			return
		$(value).html(matchedCells[0].substring(7))
		return true)
	return true

#return array<element>
$.fn.getAllSudoCells = () ->
  thisObj = $(this)
  orgNodes = $('[id^="cell"]', thisObj)
  return orgNodes


