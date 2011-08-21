//IE doesn't support string[], have to change it to charAt() 06/10/2009
function genCells(orgCells) {
  var allCells = orgCells;
  var patrn = /(cell[1-9]{2}:)([^1-9]|$)/g
  allCells = allCells.replace(patrn, "$1123456789");
  for (var x=1; x<10; x++) {
    for (var y=1; y<10; y++) {
      if (orgCells.indexOf("cell"+x+y) >= 0) continue;
      allCells = allCells + "," + "cell"+x+y+":123456789";
    }
  }
  for (x=1; x<10; x++) {
    for (var y=1; y<10; y++) {
      var patrn = new RegExp("cell"+x+y+":[1-9]{1}([^1-9]|$)", "g");
      var matchedCells = allCells.match(patrn);
      if (matchedCells && matchedCells.length == 1) continue;
      var relevantCells= getAllRelevantCells(allCells, "cell"+x+y);
      var confirmedV = getConfirmedV(relevantCells);
      patrn = new RegExp("cell"+x+y+":[1-9]{2,9}", "g"); //get original cell and update
      matchedCells = allCells.match(patrn);
      if (!matchedCells || matchedCells.length != 1) continue;
      var newC = cellsMinusValues(matchedCells[0], confirmedV);
      allCells = updateCells(allCells, newC);
    }
  }
  return allCells;
}

function verifyNineCells(nineCells) {
  var confirmedV = getConfirmedV(nineCells);
  var afterSortedV = stringMinus_SORTED_UNIQUE(confirmedV);
  if (afterSortedV && confirmedV && afterSortedV.length != confirmedV.length) return "invalid";
  return nineCells;
}

function verifyGrid(allCells) {
  var patrn = new RegExp("cell[1-9]{2}:[1-9]+", "g");
  var matchedCells = allCells.match(patrn);
  if (!matchedCells || matchedCells.length != 81) return "invalid";
  
  var newCells = gothroughRCG(allCells, verifyNineCells);
  if (newCells == "invalid") return "invalid";
  patrn = new RegExp("cell[1-9]{2}:[1-9]{1}([^1-9]|$)", "g");
  matchedCells = allCells.match(patrn);
  if (matchedCells && matchedCells.length == 81) return "solved";
  return "unresolved";
}

function gridEqual(gridA, gridB) {
  if (!gridA || !gridB) return false;
  var patrn = new RegExp("cell[1-9]{2}:[1-9]*", "g");
  var cellsOfB = gridB.match(patrn);
  var cellsOfA = gridA.match(patrn);
  if (!cellsOfB || !cellsOfA || cellsOfB.length != cellsOfA.length) return false;
  for (var i=0; i<cellsOfB.length; i++) {
    patrn = new RegExp(cellsOfB[i]+"([^1-9]|$)", "g");
    if (!gridA.match(patrn)) return false;
  }
  return true;
}

//"12356666477778669"-"235"="146789"
function stringMinus_SORTED_UNIQUE(stringA, stringB) {
  if (typeof(stringB) == "undefined") stringB = "";
  if (!stringA) return null;
  if (stringA.length == 0 || stringA == "") return null;
  //sort
  var strContainer = [];
  for (var i=0; i<stringA.length; i++) {
    strContainer.push(stringA.charAt(i));
  }
  strContainer = strContainer.sort();
  //fix redundant
  stringA = "";
  var strLen = 0;
  while (strContainer.length){
    var v=strContainer.shift();
    if (stringA && strLen > 0 && stringA.charAt(strLen-1) == v) continue;
    stringA = stringA + v;
    strLen ++;
  }
  //string minus
  for (var x=0; x<stringB.length; x++) {
    var patrn = new RegExp(stringB.charAt(x), "g");
    stringA = stringA.replace(patrn, "");
  }
  return stringA;
}

function getCountOfSolvedRCG(orgCells) {
  //rows
  var rows=genRows(orgCells);
  var solvedCount = 0;
  for (var x=0; x<9; x++) {
    if (isSolvedNineCells(rows[x])) solvedCount++;;
  }
  //col
  var cols=genCols(orgCells);
  for (var y=0; y<9; y++) {
    if (isSolvedNineCells(cols[y])) solvedCount++;;
  }
  //grid
  var grids = genGrids(orgCells);
  for (var g=0; g<9; g++) {
    if (isSolvedNineCells(grids[g])) solvedCount++;;
  }
  
  return solvedCount;
}

function isSolvedNineCells(nineCells) {
  var newCells = verifyNineCells(nineCells);
  if (newCells == "invalid") return false;
  var confirmedV = getConfirmedV(nineCells);
  if (!confirmedV) return false;
  if (stringMinus_SORTED_UNIQUE(confirmedV).length == 9) return true;
  return false;
}

function getPossibleV(allCells, cellx) {
  var relevantCells = getAllRelevantCells(allCells, cellx);
  if (!relevantCells || relevantCells == "") return "123456789";
  var confirmedV = getConfirmedV(relevantCells);
  return stringMinus_SORTED_UNIQUE("123456789", confirmedV);
}

function isConfirmedC(orgCells, cellx) {
  if (!cellx || cellx.length < 8) return false;
  var matchedCells = cellx.match(/cell[1-9]{2}:[1-9]{1}([^1-9]|$)/g);
  if (!matchedCells || matchedCells.length != 1) return false;
  var relevantCells = getAllRelevantCells(orgCells, cellx);
  var confirmedV = getConfirmedV(relevantCells);
  if (confirmedV && confirmedV.indexOf(cellx.charAt(7)) >= 0) return false;
  return true;
}

function getConfirmedV(orgCells) {
  var patrn = /cell[1-9]{2}:[1-9]{1}([^1-9]|$)/g;
  var confirmedCells = orgCells.match(patrn);
  if (!confirmedCells) return "";
  var confirmedV = "";
  for (var i=0; i<confirmedCells.length; i++) {
    confirmedV = confirmedV + confirmedCells[i].substring(7, 8);
  }
  return confirmedV;
}

function getConfirmedCells(orgCells) {
  var patrn = /cell[1-9]{2}:[1-9]{1}([^1-9]|$)/g;
  var confirmedCells = orgCells.match(patrn);
  if (!confirmedCells) return "";
  var confirmedC = "";
  for (var i=0; i<confirmedCells.length; i++) {
    confirmedC = confirmedC + "," + confirmedCells[i];
  }
  return confirmedC;
}

function getNotConfirmedCells(orgCells) {
  var patrn = /cell[1-9]{2}:[1-9]{2,9}/g;
  var notConfirmedCells = orgCells.match(patrn);
  return notConfirmedCells;
}

function getNotConfirmedV(orgCells) {
  //dont use stringMinus_SORTED_UNIQUE("123456789", confirmedV), for orgCells could be just part of a row/grid/col
  var patrn = /cell[1-9]{2}:[1-9]{2,9}/g;
  var notConfirmedCells = orgCells.match(patrn);
  if (!notConfirmedCells) return "";
  var notConfirmedV = "";
  for (var i=0; i<notConfirmedCells.length; i++) {
    notConfirmedV = notConfirmedV + notConfirmedCells[i].substring(7);
  }
  return stringMinus_SORTED_UNIQUE(notConfirmedV);
}

function getConflictCells(orgCells, cellx) {
  if (!cellx || cellx.length != 8) return "";
  var relevantCells = getAllRelevantCells(orgCells, cellx);
  var patrn = new RegExp("cell[1-9]{2}:"+cellx.charAt(7), "g");
  var conflictCells = orgCells.match(patrn);
  if (!conflictCells) return "";
  var conflictC = "";
  for (var i=0; i<conflictCells.length; i++) {
    conflictC = conflictC + conflictCells[i];
  }
  conflictC = conflictC.replace(cellx, "");
  return conflictC;
}

function genRows(orgCells, cellx) {
  var rows = [];
  var startX = 1;
  var endX = 10;
  if (typeof(cellx) != 'undefined'){
    startX = parseInt(cellx.charAt(4)); //just beause IE8 doesn't support cellx[4]
    endX = startX+1;
  }
  
  for (var x=startX; x<endX; x++) {
    var patrn = new RegExp("cell"+x+"[1-9]{1}:[1-9]{1,9}", "g");
    var matchedCells = orgCells.match(patrn);
    if (!matchedCells) continue;
    rows[x-startX] = "";
    for (var i=0; i<matchedCells.length; i++) {
      rows[x-startX] = rows[x-startX] + "," + matchedCells[i];
    }
  }
  
  return rows;
}

function genCols(orgCells, cellx) {
  var cols = [];
  var startY = 1;
  var endY = 10;
  if (typeof(cellx) != 'undefined'){
    startY = parseInt(cellx.charAt(5));//just beause IE8 doesn't support cellx[4]
    endY = startY+1;
  }
  
  for (var y=startY; y<endY; y++) {
    var patrn = new RegExp("cell[1-9]{1}"+y+":[1-9]{1,9}", "g");
    var matchedCells = orgCells.match(patrn);
    if (!matchedCells) continue;
    cols[y-startY] = "";
    for (var i=0; i<matchedCells.length; i++) {
      cols[y-startY] = cols[y-startY] + "," + matchedCells[i];
    }
  }
  
  return cols;
}

function genGrids(orgCells, cellx) {
  var grids = [];
  var startX = 1;
  var endX = 10;
  var startY = 1;
  var endY = 10;
  if (typeof(cellx) != 'undefined'){
    startX = 3*Math.floor((parseInt(cellx.charAt(4))-1)/3)+1;
    endX = startX + 3;
    startY =  3*Math.floor((parseInt(cellx.charAt(5))-1)/3)+1;
    endY = startY + 3;
  }
  
  var g = 0;
  //get grids
  for (var startRow=startX; startRow<endX; startRow+=3) {
    for (var startCol=startY; startCol<endY; startCol+=3) {
      grids[g] = "";
      for (var x=startRow; x<startRow+3; x++) {
        for (var y=startCol; y<startCol+3; y++) {
          var patrn = new RegExp("cell"+x+y+":[1-9]{1,9}", "g");
          var matchedCells = orgCells.match(patrn);
          if (!matchedCells) continue;
          grids[g] = grids[g]+","+matchedCells[0];
        }
      }
      g++;
    }
  }
  return grids;
}

function getAllRelevantCells(allCells, cellx) {
  var rows = genRows(allCells, cellx);
  var cols = genCols(allCells, cellx);
  var grids = genGrids(allCells, cellx);
  var relevantCells = rows[0]+cols[0]+grids[0];
  var patrn = new RegExp(cellx.substring(0,6)+":[1-9]{1,9}", "g");
  relevantCells = relevantCells.replace(patrn, "");
  
  return relevantCells;
}

function updateCells(orgCells, cells) {
  var patrn = new RegExp("(cell[1-9]{2}:)"+"([1-9]*)", "g");
  var matchedCells = cells.match(patrn);
  if (!matchedCells) return orgCells;
  for (var i=0; i<matchedCells.length; i++) {
    var tmpPtn = new RegExp("("+matchedCells[i].substring(0, 7)+")"+"([1-9]*)", "g");
    orgCells = orgCells.replace(tmpPtn, "$1"+matchedCells[i].substring(7));
  }
  return orgCells;
}

function updateCellsAfterOneConfirmed(orgCells, confirmedCell) {
  var relevantCells = getAllRelevantCells(orgCells, confirmedCell);
  var patrn = new RegExp("(cell[1-9]{2}:)"+"([1-9]*)("+confirmedCell.charAt(7)+")([1-9]*)"); //?? questionable here
  for (var i=0; i<relevantCells.length; i++) {
    relevantCells[i] = relevantCells[i].replace(patrn, "$1$2$4");
    relevantCells[i] = relevantCells[i].replace(confirmedCell.substring(0, 7), confirmedCell);
    orgCells = updateCells(orgCells, relevantCells[i]);
  }
  return orgCells;
}

//return ["cellxx:v,cellxx:v", ...]
function getCombinedCells(cellsArray, grpSize) {
  if (!cellsArray || cellsArray.length < grpSize) return null;
  var xxCells = [];
  if (grpSize == 1) {
    return cellsArray;
  }
  if (cellsArray.length == grpSize) {
    var cell_xx = "";
    for (var xx=0; xx<grpSize; xx++) {
      cell_xx = cell_xx + "," + cellsArray[xx];
    }
    xxCells.push(cell_xx);
    return xxCells;
  }
  var tmpA = [];
  for (var i=0; i<cellsArray.length; i++) {
    tmpA.push(cellsArray[i]);
  }
  for (var i=0; i<cellsArray.length-grpSize+1; i++) {
    tmpA.shift();
    var combinedA = getCombinedCells(tmpA, grpSize-1);
    for (var j=0; j<combinedA.length; j++) {
      xxCells.push(cellsArray[i]+","+combinedA[j]);
    }
  }
  return xxCells;
}

function cellsMinusCells(cellsA, cellsB) {
  if (typeof(cellsB) == "undefined" || cellsB == "") return cellsA;
  var patrn = new RegExp("cell[1-9]{2}:"+"[1-9]{1,9}", "g");
  var cellsOfB = cellsB.match(patrn);
  if (!cellsOfB) return cellsA;
  for (var i=0; i<cellsOfB.length; i++) {
    cellsA = cellsA.replace(cellsOfB[i], "");
  }
  patrn = new RegExp(",+", "g");
  cellsA = cellsA.replace(patrn, ",");
  return cellsA;
}

function cellsMinusValues(orgCells, rangeOfV) {
  var patrn = new RegExp("cell[1-9]{2}:"+"[1-9]{2,9}", "g");
  var unresolvedCells = orgCells.match(patrn);
  if (!unresolvedCells) return orgCells;
  orgCells = "";
  for (var i=0; i<unresolvedCells.length; i++) {
    var newC = stringMinus_SORTED_UNIQUE(unresolvedCells[i].substring(7), rangeOfV);
    orgCells = orgCells + "," + unresolvedCells[i].substring(0,7)+newC;
  }
  return orgCells;
}

function nDigits_In_nCells(nineCells) {
  var patrn = new RegExp("cell[1-9]{2}:"+"[1-9]{2,9}", "g");
  var unresolvedCells = nineCells.match(patrn);
  if (!unresolvedCells || unresolvedCells.length < 3) return nineCells;
  var allUnresolvedCells = "";
  for (var i=0; i<unresolvedCells.length; i++) {
    allUnresolvedCells = allUnresolvedCells + "," + unresolvedCells[i];
  }
  if (!unresolvedCells || unresolvedCells.length < 3) return nineCells;
  for (var xx=2; xx<unresolvedCells.length; xx++) {
    var xxCombinedCells = getCombinedCells(unresolvedCells, xx);
    for (var yy=0; yy<xxCombinedCells.length; yy++) {
      var possibleV = getNotConfirmedV(xxCombinedCells[yy]);
      if (possibleV.length == xx) {
        var leftCells = cellsMinusCells(allUnresolvedCells, xxCombinedCells[yy]);
        leftCells = cellsMinusValues(leftCells, possibleV);
        nineCells = updateCells(nineCells, leftCells);
        return nineCells;
      }
    }
  }
  return nineCells;
}

function refuge(nineCells) {
  var patrn = new RegExp("cell[1-9]{2}:"+"[1-9]{2,9}", "g");
  var unresolvedCells = nineCells.match(patrn);
  if (!unresolvedCells) return nineCells;
  for (var i=0; i<unresolvedCells.length; i++) {
    var cellV = unresolvedCells[i].substring(7);
    for (var xx=0; xx<cellV.length; xx++) {
      patrn = new RegExp("cell[1-9]{2}:"+"([1-9]*)"+cellV.charAt(xx)+"([1-9]*)", "g");
      if (nineCells.match(patrn).length > 1) continue;
      var confirmedCell = unresolvedCells[i].substring(0, 7)+cellV.charAt(xx);
      nineCells = updateCells(nineCells, confirmedCell);
      return nineCells;
    }
  }
  return nineCells;
}

function gothroughRCG(orgCells, fnRules){
  //rows
  var rows=genRows(orgCells);
  var newCells = "";
  for (var x=0; x<9; x++) {
    rows[x] = fnRules(rows[x]);
    if (rows[x] == null || rows[x] == "invalid") return "invalid";
    newCells = newCells+","+rows[x];
  }
  if (!gridEqual(newCells, orgCells)) orgCells = genCells(newCells);
  //col
  var cols=genCols(orgCells);
  newCells = "";
  for (var y=0; y<9; y++) {
    cols[y] = fnRules(cols[y]);
    if (cols[y] == null || cols[y] == "invalid") return "invalid";
    newCells = newCells+","+cols[y];
  }
  if (!gridEqual(newCells, orgCells)) orgCells = genCells(newCells);
  //grid
  var grids = genGrids(orgCells);
  newCells = "";
  for (var g=0; g<9; g++) {
    grids[g] = fnRules(grids[g]);
    if (grids[g] == null || grids[g] == "invalid") return "invalid";
    newCells = newCells+","+grids[g];
  }
  if (!gridEqual(newCells, orgCells)) {
    orgCells = genCells(newCells);
  } else {
    orgCells = newCells;
  }
  
  return orgCells;
}

function findAnswer(allCells, guessing, difficultyLevel){
  switch (verifyGrid(allCells)) {
    case "invalid": return "invalid";
    case "solved": return allCells;
  }
  
  if (typeof(guessing) == "undefined") guessing = true;
  if (typeof(difficultyLevel) == "undefined") difficultyLevel = 1;
  var patrn = new RegExp("cell[1-9]{2}:[1-9]{1}([^1-9]|$)", "g");
  var matchedCells;
  var loopCount = 0;
  while (loopCount < 2) {
    var workingCells = gothroughRCG(allCells, refuge);
    switch (verifyGrid(workingCells)) {
      case "invalid": return "invalid";
      case "solved": 
        alert("Difficulty: "+difficultyLevel);
        return workingCells;
    }
    workingCells = gothroughRCG(workingCells, nDigits_In_nCells);
    switch (verifyGrid(workingCells)) {
      case "invalid": return "invalid";
      case "solved": 
        alert("Difficulty: "+difficultyLevel);
        return workingCells;
    }
    difficultyLevel++;
    if (gridEqual(workingCells, allCells)) {
      loopCount = loopCount + 1;
      if (loopCount == 2 && getCountOfSolvedRCG(workingCells) < 5) return "unresolved";
      if (loopCount == 2 && guessing) {
        var unresolvedCells = getNotConfirmedCells(workingCells);
        var callsGuard = 0;
        for (var xx=0; xx<unresolvedCells.length; xx++) {
          //difficultyLevel++;
          for (var yy=0; yy<unresolvedCells[xx].substring(7).length; yy++) {
            var tmpCells = updateCells(workingCells, unresolvedCells[xx].substring(0,7)+unresolvedCells[xx].charAt(7+yy));
            tmpCells = findAnswer(tmpCells, false, difficultyLevel);
            if (tmpCells == "invalid") {
              var newC = cellsMinusValues(unresolvedCells[xx], unresolvedCells[xx].charAt(7+yy));
              workingCells = updateCells(workingCells, newC);
              return findAnswer(workingCells, true, difficultyLevel);
            }else if (tmpCells == "unresolved"){
              continue;
            }
            else {
              return tmpCells;
            }
          }
        }
        loopCount = 0;
      }
    }
    else {
      loopCount = 0;
    }
    allCells = workingCells;
  }
  return "unresolved";
}

