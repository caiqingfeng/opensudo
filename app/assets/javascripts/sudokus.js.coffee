# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

rowsOfGrid = ["11, 12, 13, 14, 15, 16, 17, 18, 19",
				"21, 22, 23, 24, 25, 26, 27, 28, 29",
				"31, 32, 33, 34, 35, 36, 37, 38, 39",
				"41, 42, 43, 44, 45, 46, 47, 48, 49",
				"51, 52, 53, 54, 55, 56, 57, 58, 59",
				"61, 62, 63, 64, 65, 66, 67, 68, 69",
				"71, 72, 73, 74, 75, 76, 77, 78, 79",
				"81, 82, 83, 84, 85, 86, 87, 88, 89",
				"91, 92, 93, 94, 95, 96, 97, 98, 99"]

colsOfGrid = ["11, 21, 31, 41, 51, 61, 71, 81, 91",
				"12, 22, 32, 42, 52, 62, 72, 82, 92",
				"13, 23, 33, 43, 53, 63, 73, 83, 93",
				"14, 24, 34, 44, 54, 64, 74, 84, 94",
				"15, 25, 35, 45, 55, 65, 75, 85, 95",
				"16, 26, 36, 46, 56, 66, 76, 86, 96",
				"17, 27, 37, 47, 57, 67, 77, 87, 97",
				"18, 28, 38, 48, 58, 68, 78, 88, 98",
				"19, 29, 39, 49, 59, 69, 79, 89, 99"]

gridsOfGrid = ["11, 12, 13, 21, 22, 23, 31, 32, 33",
				"14, 15, 16, 24, 25, 26, 34, 35, 36",
				"17, 18, 19, 27, 28, 29, 37, 38, 39",
				"41, 42, 43, 51, 52, 53, 61, 62, 63",
				"44, 45, 46, 54, 55, 56, 64, 65, 66",
				"47, 48, 49, 57, 58, 59, 67, 68, 69",
				"71, 72, 73, 81, 82, 83, 91, 92, 93",
				"74, 75, 76, 84, 85, 86, 94, 95, 96",
				"77, 78, 79, 87, 88, 89, 97, 98, 99"]

groupCells = []
groupCells[0..8] = rowsOfGrid[0..8]
groupCells[9..17] = colsOfGrid[0..8]
groupCells[18..26] = gridsOfGrid[0..8]

#mark all possible digits of one cell
greedyMark = (cellString, workingCells) ->
	patrn_0 = new RegExp("[1-9]{2}", "g")
	newCellString = cellString
	for xx in workingCells.match(patrn_0)
		patrn = new RegExp("cell"+xx+":[1-9]{1}([^1-9]|$)", "g")
		continue if newCellString.match(patrn)
		tmpCell = "cell"+xx+":123456789" 
		patrn = new RegExp("cell"+xx+":[1-9]*", "g")
		matchResult = newCellString.match(patrn)
		tmpCell = matchResult[0] if matchResult && matchResult.length == 1 && matchResult[0].length > 7
		tmpCell = clearCell(newCellString, workingCells, tmpCell)
		return null if tmpCell.length == 7
		if !matchResult 
			newCellString = newCellString + tmpCell + "," 
		else 
			newCellString = newCellString.replace(patrn, tmpCell)
	return newCellString

#input "11, 12, 13.." or "cell11, cell12, ..." return "cell(11|12|13...)"
genRelevantPatternString = (workingCells) ->
	patrn_0 = new RegExp("[1-9]{2}", "g")
	cell_xy_s = workingCells.match(patrn_0)
	patrn_string = "cell("
	for xx in cell_xy_s
		patrn_string = patrn_string + xx + "|"
	#remove last | by calling substring
	patrn_string = patrn_string.substring(0, patrn_string.length) + ")"
	return patrn_string

#called by n_IN_n	
getCombinedCells = (cellsArray, grpSize) ->
	return null if (!cellsArray || cellsArray.length < grpSize)
	xxCells = []
	return cellsArray if (grpSize == 1)
	if (cellsArray.length == grpSize) 
		cell_xx = ""
		for xx in cellsArray
			cell_xx = cell_xx + "," + xx
		xxCells.push(cell_xx)
		return xxCells
	tmpA = []
	for xx in cellsArray
		tmpA.push(xx)
	for i in [0..cellsArray.length-grpSize]
		tmpA.shift()
		combinedA = getCombinedCells(tmpA, grpSize-1)
		for xx in combinedA
			xxCells.push(cellsArray[i]+","+xx)
	return xxCells
	
#if cell11:24 and cell12:24 then all other cells could not be 2 or 4
#first time called by findAnswer(allCellString, groupCells)
#then called by itself by (nineCellString, unresolvedCells)
n_IN_n = (cellString, workingCells) ->
	#only update working cells
	patrn_string = genRelevantPatternString(workingCells)+":[1-9]*"
	patrn = new RegExp(patrn_string, "g")
	newCellString = ""
	for xx in cellString.match(patrn)
		newCellString = newCellString+xx+","
	newCellString = newCellString.substring(0, newCellString.length)
	#newCellString is now only nineCells
	patrn_string = genRelevantPatternString(workingCells)+":[1-9]{2,}"
	patrn = new RegExp(patrn_string, "g")
	unresolvedCells = newCellString.match(patrn)
	#doen't work for only two cells not solved
	return cellString if !unresolvedCells || unresolvedCells.length < 3
	for combinationSize in [2..unresolvedCells.length-1]
		for xx in getCombinedCells(unresolvedCells, combinationSize)
			#get all possible values
			tmpV = ""
			tmpPatrn = new RegExp("cell[1-9]{2}:[1-9]{2,}", "g")
			for yy in xx.match(tmpPatrn)
				tmpV = tmpV+yy.substring(7)
			#delete repetition
			possibleV = ""
			for v in [1..9]
				tmpPatrn = new RegExp(v)
				possibleV = possibleV+v if tmpV.match(tmpPatrn)
			#core functionality here
			if possibleV.length == combinationSize
				patrn = new RegExp("cell[1-9]{2}:[1-9]{2,}", "g")
				valueMatched = possibleV.replace /./g, (match) ->
					match = match+"|"
				valueMatched = "("+valueMatched.substring(0, valueMatched.length)+")"
				valueMatchedPatrn = new RegExp(valueMatched, "g")
				for tmpCell in newCellString.match(patrn)
					#if it's not listed in combinedCells then its value should get rid of possibleV
					patrn = new RegExp(tmpCell, "g")
					if !xx.match(patrn)
						orgV = tmpCell.substring(7)
						newV = orgV.replace(valueMatchedPatrn, "")
						tmpString = tmpCell.substring(0, 7)+newV
						newCellString = updateCells(newCellString, tmpString)
		
	return updateCells(cellString, newCellString)

randomGuess = (cellString, workingCells) ->
	patrn = new RegExp("cell[1-9]{2}:[1-9]{2,}([^1-9]|$)", "g")
	matchedResult = cellString.match(patrn)
	return cellString if !matchedResult || matchedResult.length > 55
	patrn_string = genRelevantPatternString(workingCells)+":[1-9]{2}([^1-9]|$)"
	patrn = new RegExp(patrn_string, "g")
	matchedResult = cellString.match(patrn)
	return cellString if !matchedResult || matchedResult.length < 2
	newCellString = cellString
	for xx in matchedResult
		for vv in xx.substring(7).match(/[1-9]{1}/g)
			tmpCell = xx.substring(0, 7)+vv
			newCellString = updateCells(cellString, tmpCell)
			#check if this guess is right, it is easy to exclude this guess when finding out grid is wrong
			#or completed. If it needs second guess (not completed nor wrong), it is difficult.
			newCellString = findAnswer(newCellString, 0, "learner")
			continue if newCellString == null
			return newCellString if completedGrid(newCellString)
			#needs second guess then
			newCellString = randomGuess(newCellString, workingCells)
			continue if newCellString == null
			return newCellString if completedGrid(newCellString)
	return cellString

#http://tieba.baidu.com/p/342242521?pn=1
#if a number is determined to be in one line of a grid, then the rest of the line should not comprise of this number
#for example, '9' in col 3, and line 1 and line 3 of grid 1 have certain numbers, then '9' should be in line 2 of grid 1, then the rest of line 2 should not comprise of '9'
#the workingCells should be only grid
reflection = (cellString, workingCells) ->
	patrn_string = genRelevantPatternString(workingCells)+":[1-9]*"
	patrn = new RegExp(patrn_string, "g")
	newCellString = ""
	for xx in cellString.match(patrn)
		newCellString = newCellString+xx+","
	newCellString = newCellString.substring(0, newCellString.length)
	#newCellString is now only nineCells
	updatedCells = cellString
	for vv in [1..9]
		patrn_string = genRelevantPatternString(workingCells)+":[1-9]*"+vv+"[1-9]*"
		patrn = new RegExp(patrn_string, "g")
		digitalInCells = newCellString.match(patrn)
		if digitalInCells && digitalInCells.length in [2..3]
			patrn_string = ""
			sameRow = digitalInCells[0].charAt(4)
			sameCol = digitalInCells[0].charAt(5)
			colsOfThatGrid = ""
			rowsOfThatGrid = ""
			for xx in digitalInCells
				sameRow = "" if xx.charAt(4) != sameRow
				colsOfThatGrid = colsOfThatGrid+xx.charAt(5)
				sameCol = "" if xx.charAt(5) != sameCol
				rowsOfThatGrid = rowsOfThatGrid+xx.charAt(4)
			if sameRow != ""
				#clear row
				patrn_string = "cell"+sameRow+"("
				for colXX in [1..9]
					patrn_string = patrn_string+colXX+"|" if !colsOfThatGrid.match(colXX) 
				patrn_string = patrn_string.substring(0, patrn_string.length)+")"+":[1-9]*"+vv+"[1-9]*"
			if sameCol != ""
				#clear col
				patrn_string = "cell"+"("
				for rowXX in [1..9]
					patrn_string = patrn_string+rowXX+"|" if !rowsOfThatGrid.match(rowXX)
				patrn_string = patrn_string.substring(0, patrn_string.length)+")"+digitalInCells[1].charAt(5)+":[1-9]*"+vv+"[1-9]*"
			if patrn_string != ""
				patrn = new RegExp(patrn_string, "g")
				tmpMatch = updatedCells.match(patrn)
				continue if !tmpMatch
				for xx in tmpMatch
					possibleV = xx.substring(7)
					if possibleV.match(vv)
						possibleV = possibleV.replace(vv, "")
						newCell = xx.substring(0, 7)+possibleV
						updatedCells = updateCells(updatedCells, newCell)
	return updatedCells

fnBasicTricks = [greedyMark, n_IN_n, randomGuess]
fnBasicTricksWithoutGuess = [greedyMark, n_IN_n]
fnAdvancedTricks = [reflection]

getConfirmedCells = (cellString) ->
	patrn = new RegExp("cell[1-9]{2}:[1-9]{1}([^1..9]|$)", "g")
	#patrn.global = true
	return cellString.match(patrn)
	
updateCells = (orgCells, updatedCells) ->
	newCellString = orgCells
	patrn = new RegExp("cell[1-9]{2}:[1-9]*", "g")
	for xx in updatedCells.match(patrn)
		patrn = new RegExp(xx.substring(0, 7)+"[1-9]*", "g")
		newCellString = newCellString.replace(patrn, xx)
	return newCellString
	
#called by greedyMark, to clear a cell's possible values to check all relevant cells conflict	
clearCell = (cellString, workingCells, cellxy) ->
	return cellxy if cellxy.length == 8
	xy = cellxy.substring(4, 6)
	patrn = new RegExp(xy, "g")
	#cellxy must be part of workingCells
	return null if !workingCells.match(patrn)
	possibleV = cellxy.substring(7)
	clearV = ""
	for vv in possibleV.match(/[1-9]{1}/g)
		patrn_string = genRelevantPatternString(workingCells)+":"+vv+"([^1-9]|$)"
		patrn = new RegExp(patrn_string, "g")
		clearV = clearV + vv if !cellString.match(patrn)

	return "cell"+xy+":"+clearV

#solverLevel:
#"guru": guess
#"master": firstly try basic tricks then use guess
#"learner": just use basic tricks
findAnswer = (cellString, stackLevel, solverLevel) ->
	return cellString if cellString == null
	if stackLevel > 4
		return cellString if solverLevel == "guru" || solverLevel == "learner"
		if solverLevel == "master"
			patrn = new RegExp("cell[1-9]{2}:[1-9]{1}", "g")
			matchedResult = cellString.match(patrn)
			if matchedResult && matchedResult.length > 17
				return findAnswer(cellString, 0, "guru") 
	arrayBasicTricks = fnBasicTricksWithoutGuess 
	arrayBasicTricks = fnBasicTricks if solverLevel == "guru" 
	newCellString = cellString
	#basic trick, checking only for one row or one col or one grid
	for fnTrick in arrayBasicTricks
		for groupCell in groupCells
			return newCellString if newCellString == null || completedGrid(newCellString)
			newCellString = fnTrick(newCellString, groupCell)
	return newCellString if newCellString == null || completedGrid(newCellString)
	#advanced trick, checking grid first and then check relevant row or col
	for fnTrick in fnAdvancedTricks
		for gridCell in gridsOfGrid
			return newCellString if newCellString == null || completedGrid(newCellString)
			newCellString = fnTrick(newCellString, gridCell)
	return newCellString if newCellString == null || completedGrid(newCellString)
	return findAnswer(newCellString, stackLevel+1, solverLevel)

$.fn.findAnswer = (cellString, stackLevel) ->
	return findAnswer(cellString, stackLevel, "master")

$.fn.greedyMark = (orgCells, editableGrid) ->
	newCellString = $(this).genString()
	for fnRule in [greedyMark]
		for groupCell in groupCells
			if $(this).completedGrid(newCellString)
				$(this).setGrid(newCellString, orgCells, editableGrid)
				return newCellString
			newCellString = fnRule(newCellString, groupCell)
			return null if newCellString == null
	$(this).setGrid(newCellString, orgCells, editableGrid)
	return newCellString

$.fn.reflection = (orgCells, editableGrid) ->
	newCellString = $(this).genString()
	for fnRule in [reflection]
		for groupCell in gridsOfGrid
			if $(this).completedGrid(newCellString)
				$(this).setGrid(newCellString, orgCells, editableGrid)
				return newCellString
			newCellString = fnRule(newCellString, groupCell)
	$(this).setGrid(newCellString, orgCells, editableGrid)
	return newCellString

$.fn.n_IN_n = (orgCells, editableGrid) ->
	newCellString = $(this).genString()
	for fnRule in [n_IN_n]
		for groupCell in groupCells
			return newCellString if $(this).completedGrid(newCellString)
			newCellString = fnRule(newCellString, groupCell)
	$(this).setGrid(newCellString, orgCells, editableGrid)
	return newCellString

completedGrid = (cellString) ->
	patrn = new RegExp("cell[1-9]{2}"+":[1-9]{1}"+"([^1-9]|$)", "g")
	completedCells = cellString.match(patrn)
	return false if !completedCells || completedCells.length != 81
	#row by row, col by col and then grid by grid
	for v in [1..9]
		for groupCell in groupCells
			patrn_string = genRelevantPatternString(groupCell)+":" + v + "([^1-9]|$)"
			patrn = new RegExp(patrn_string, "g")
			matchedResult = cellString.match(patrn)
			return false if !matchedResult || matchedResult.length != 1
	return true
		
$.fn.completedGrid = (cellString) ->
	return completedGrid(cellString)
	
$.fn.text2Sudo = (orgCells) ->
	i = 0
	newCellString = ""
	for rr in rowsOfGrid
		for xx in rr.match(/[1-9]{2}/g)
			newCellString = newCellString+"cell"+xx+":"+orgCells[i]+"," if orgCells[i] <= '9' && orgCells[i] >= '0'
			i++
			i++ if orgCells[i] in [',', ' ', '|', '\n']
	newCellString = newCellString.substring(0, newCellString.length)
	return newCellString
	
	