# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ = jQuery
$.fn.sudoku = (options_par) -> 
	alert("happy, birthday!")
	defaults = {
		cssClassName: "classic",      	
		level: 0,
		playable: true, 
		playableCallback: null
		editable: false, 
		editableCallback: null
	}
	
	options = $.extend(defaults, options_par)
	thisObj = $(this)
	alert('ddd')
	orgCells = thisObj.attr("cells")
	readonlyCells = thisObj.attr("readonlyCells")
	options.level = thisObj.attr("sudoLevel") if options.level is 0
	if $('table', thisObj).length == 0
		thisObj.append('<p>test</p>')
	alert("happy, birthday!")