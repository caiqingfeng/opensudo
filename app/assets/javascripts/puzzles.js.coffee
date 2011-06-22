# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require sudokus

$ = jQuery

clickOnEdit = (content) -> 
	return true

options = {editableCallback: clickOnEdit, playable: false, editable: true}

#create table by the parameter cellString
#set readOnly cells by readOnly parameter
#new puzzle or play puzzle (show puzzle)

$(document).ready -> 
	$(this).initGrid()
	$('#content').createTable("cell11:1", "Cee")

#sudoku(options)

$.fn.createTable = (cellString, readOnly) ->
#	alert(cellString+readOnly)
	cssName = "standard"
	allCells = initializeGrid(cellString)
#	alert(allCells)
	return true


