function load() {
	if (GBrowserIsCompatible()) {
		var map = new GMap2(document.getElementById("map"));
		map.addControl(new GLargeMapControl());
		map.addControl(new GScaleControl());
		map.addControl(new GMapTypeControl());
		map.setCenter(new GLatLng(xCoordOnLoad, yCoordOnLoad), zoomOnLoad);
		map.enableContinuousZoom();
		var linePoints = [];
		var lineLabels = [];	
		
		GDownloadUrl(tipProjectGeogFile, function(data, responseCode) {
			var xml = GXml.parse(data);
			var xmlLines = xml.documentElement.getElementsByTagName("line");
			
			for (var l=0; l<xmlLines.length; l++) {
				var Epoints = xmlLines[l].getAttribute("points");
				var Elevels = xmlLines[l].getAttribute("levels");
				
				var mypolyline = new GPolyline.fromEncoded({color: "#FF0000",
															weight: 5,
															points: Epoints,
															levels: Elevels,
															zoomFactor: 16,
															numLevels: 4});
				map.addOverlay(mypolyline);
			}
		});
		
		GDownloadUrl(tipProjectLabelFile, function(data,responseCode) {
			var xml = GXml.parse(data);
			var xmlLabels = xml.documentElement.getElementsByTagName("line");
			for (var l=0; l<xmlLabels.length; l++) {
				var pointLabel = xmlLabels[l].getAttribute("lname");
				var points = xmlLabels[l].getElementsByTagName("vertex");
				for (var j = 0; j < points.length; j++) {
					var point = new GLatLng(parseFloat(points[j].getAttribute("lat")),
											parseFloat(points[j].getAttribute("lng")));
					lineLabels.push(point);
					map.addOverlay(createMarker(point, pointLabel));
				}
			}
		});
	
	}
}


function createMarker(point, label) {
	var marker = new GMarker(point);
	GEvent.addListener(marker, "click", function() {
		var labelHtml;
		//labelHtml = "<nbsp><b>" + label + "</b> ";
		labelHtml = "";
		//labelHtml = labelHtml + "<br/><a href= '../commentform.htm'>Comment on this project<a>"
		labelHtml = labelHtml + "<br/><b>See project data below.</b>";
		marker.openInfoWindowHtml(labelHtml);		
		var desc = writeProjData(label);
	});
	return marker;
}

function writeProjData(projID){
	// define and empty the div and span that will display the project data
	var dataDiv = document.getElementById("projectData");
	var titleSpan = document.getElementById("projDataSpan");
	if(dataDiv.hasChildNodes()){
		dataDiv.removeChild(dataDiv.lastChild)
	}
	var thisDesc = "";
	GDownloadUrl(projDataFile, function(data, responseCode) {
		var projDataList = GXml.parse(data);
		var thisLocation = "";
		var xmlProjects = projDataList.getElementsByTagName("project");
		var p=0;
		while (p<xmlProjects.length){
			var thisProj = xmlProjects[p];
			if (thisProj.getAttribute("projID") == projID) {
				var projectDiv = ProjDataDiv(thisProj);
				//get proj description
				thisDesc = thisProj.getAttribute("description");			
			}
			p++;
		}
		dataDiv.appendChild(projectDiv);
		projectDiv.setAttribute("class", "projDataInner"); //sets class in non-IE browsers
		projectDiv.setAttribute("className", "projDataInner"); // set class in IE
		
		titleSpan.removeChild(titleSpan.lastChild);
		titleSpan.appendChild(document.createTextNode("Project Data"));
	});
	return thisDesc;
}

function financialHeaderRow(colTitles){
	// create row element with column titles

	var headerRow = document.createElement("tr");
	var mainRow = document.createElement("tr");
	var myHeaderCells = [];
	var myHeaderSpans = [];
	var headerNum = 0;	
	while (headerNum<colTitles.length){
		myHeaderCells[headerNum] = document.createElement("td");
		myHeaderSpans[headerNum] = document.createElement("span");
		myHeaderSpans[headerNum].setAttribute("class", "dataTitle");
		myHeaderSpans[headerNum].setAttribute("className", "dataTitle");
		myHeaderSpans[headerNum].appendChild(document.createTextNode(colTitles[headerNum]));
		myHeaderCells[headerNum].appendChild(myHeaderSpans[headerNum]);
		headerRow.appendChild(myHeaderCells[headerNum]);
		headerNum = headerNum + 1;
	}	
	return headerRow;
}

function financialTitleRow(){
	// Returns a table row with the header for the financial table
	fTitleCell = document.createElement("td");
	fTitleRow = document.createElement("tr");
	var fTitleSpan = document.createElement("span");
	fTitleSpan.setAttribute("class","dataTitle");
	fTitleSpan.setAttribute("className","dataTitle");
	var fTitleText = document.createTextNode("Financial Data:");
	fTitleSpan.appendChild(fTitleText);
	fTitleCell.appendChild(fTitleSpan);
	//fTitleCell.setAttribute("colspan","3");
	fTitleCell.colSpan = "3";
	fTitleRow.appendChild(fTitleCell);
	return fTitleRow;
	//return fTitleSpan;
}

function financialDataTable(projElement){
	// create table to hold the the project details
	var financialTable = document.createElement("table");
	financialTable.setAttribute("class","details");
	financialTable.setAttribute("className","details");
	var tbdy = document.createElement("tbody");	
	var fTitle = financialTitleRow();
	tbdy.appendChild(fTitle);
	// add column headers to financialTable
	/*var colTitles = ["Phase", 
					 "Year", 
					 "Federal Funding Type", 
					 "Federal Funding", 
					 "State/ Local Funding",
					 "Other Funding",
					 "Projected Obligation Date"];
	 */
	var colTitles = ["Phase", 
					 "Year", 
					 "Funding Type", 
					 "Funding", 
					 "Projected Obligation Date"];
	var headerRow = financialHeaderRow(colTitles);	
	tbdy.appendChild(headerRow);

	// get the phase information for the project 
	var phaseDetails = projElement.getElementsByTagName("phaseDetail");
	var detailLength = phaseDetails.length;

	// create cells of phase details values
	var detailRows = [];
	for (var i=0; i<detailLength; i++) {
			var aDetailRow = document.createElement("tr");			
			var phaseCols = ["phase", 
							 "progYear", 
							 "Source", 
							 "Amount", 
							 "obDate"];		
			/*var phaseCols = ["phase", 
							 "progYear", 
							 "fedSource", 
							 "fedAmount", 
							 "matchAmount",
							 "otherAmount",
							 "obDate"];*/
			var myCells = [];
			var cellNum = 0;

			while (cellNum<phaseCols.length){
				myCells[cellNum] = document.createElement("td");
				myCells[cellNum].appendChild(document.createTextNode(phaseDetails[i].getAttribute(phaseCols[cellNum])));
				aDetailRow.appendChild(myCells[cellNum]);
				cellNum = cellNum + 1;
			}			
			tbdy.appendChild(aDetailRow);
	}	
	
	
	financialTable.appendChild(tbdy);
	return financialTable;
}

function getCommentDiv(projectID){
	var cDiv = document.createElement("div");
	var cSpan = document.createElement("span");
	cSpan.setAttribute("class", "divhead1");
	cSpan.setAttribute("className", "divhead1");
	var commentText = document.createTextNode(" Comment on this project");
	var cA = document.createElement("a");
	//cA.setAttribute("href", "./comments/gmapcommentform.htm?" + projectID);
    cA.setAttribute("href", "./gmapcommentform.htm?" + projectID);
	cA.appendChild(commentText);
	cSpan.appendChild(cA);
	cSpan.appendChild(document.createElement("br"));
	cDiv.appendChild(cSpan);
	return cDiv;
}

function ProjDataDiv(projElement) {
	var projDiv = document.createElement("div");
	var projTitleTable = document.createElement( "table" );
	projTitleTable.setAttribute( "class", "pTitle" );	
	projTitleTable.setAttribute( "className", "pTitle" );			
	var tbdy = document.createElement("tbody");
	//var projLevelData = ["title", "sponsor", "projID", "location", "description", "totCost",  "funcClass", "impType", "totPSRCFunds"];
	//var projLevelFields = ["Title", "Sponsor", "Project ID", "Location", "Description", "Total Project Cost", "Functional Class", "Improvement Type", "Total New PSRC (Federal) Funds"];
	var projLevelData = ["title", "sponsor", "projID", "location", "description", "totCost", "impType"];
	var projLevelFields = ["Title", "Sponsor", "Project ID", "Location", "Description", "Total Project Cost", "Improvement Type"];
	var projID = projElement.getAttribute(projLevelData[2]);
	var projDataRows = [];
	var majorCells = [];
	var k = 0;
	var cellTitle = [];
	var cellValue = [];
	var titleSpan = [];
	while (k<projLevelData.length){
		projDataRows[k] = document.createElement( "tr" );
		majorCells[k] = document.createElement("td");
		cellTitle[k] = document.createTextNode(projLevelFields[k] + ": ");
		cellValue[k] = document.createTextNode(projElement.getAttribute(projLevelData[k]));
		titleSpan[k] = document.createElement("span");
		titleSpan[k].setAttribute("class", "dataTitle");
		titleSpan[k].setAttribute("className", "dataTitle");
		titleSpan[k].appendChild(cellTitle[k]);
		majorCells[k].appendChild(titleSpan[k]);
		majorCells[k].appendChild(cellValue[k]);
		projDataRows[k].appendChild(majorCells[k]);
		tbdy.appendChild(projDataRows[k]);
		k = k + 1;
	}

	projTitleTable.appendChild(tbdy);
	//alert(projID);
	var financialTable = financialDataTable(projElement);
	projDiv.appendChild(projTitleTable);
	projDiv.appendChild(document.createElement("hr"));
	projDiv.appendChild(financialTable);
	projDiv.appendChild(document.createElement("br"));
	projDiv.appendChild(document.createElement("hr"));
	var commentDiv = getCommentDiv(projID);
	projDiv.appendChild(commentDiv);
	//projDiv.appendChild(document.createTextNode("Comment on this project"));
	return projDiv;
}

function showInstr() {
	var divInstructionsToggler = document.getElementById("divInstruct");
	var divInstructions = document.createElement("div");
	var spnInstructions = document.createElement("span");
	var txtInstructions = document.createTextNode("Click the zoom bar near the left margin of the map to adjust the scale.");
	var aToggle = document.getElementById("aToggle");
	var aryInstructions = ["Use the zoom bar on the left margin of the map to zoom in and out.",
							"Click and drag the map to pan.",
							"Click 'Map', 'Satellite', or 'Hybrid' to change the background.",
							"Click a project on the map to see its information and to comment."];
	var ulInstructions = document.createElement("ul");
	var i=0;
	var instructionRowLi = [];
	while (i<aryInstructions.length){
		instructionRowLi[i] = document.createElement("li");
		instructionRowLi[i].appendChild(document.createTextNode(aryInstructions[i]));
		ulInstructions.appendChild(instructionRowLi[i]);
		i = i + 1;
	}
	
	spnInstructions.appendChild(txtInstructions);
	//divInstructions.appendChild(spnInstructions);
	divInstructions.appendChild(ulInstructions);
	divInstructions.setAttribute("class", "projDataInner");
	divInstructions.setAttribute("className", "projDataInner");
	divInstructionsToggler.appendChild(divInstructions);
	aToggle.href = "javascript:void(hideInstr())";
	aToggle.removeChild(aToggle.lastChild);
	aToggle.appendChild(document.createTextNode("Hide Instructions"));
}

function hideInstr() {
	var divInstructionsToggler = document.getElementById("divInstruct");
	var aToggle = document.getElementById("aToggle");
	divInstructionsToggler.removeChild(divInstructionsToggler.lastChild);
	aToggle.href = "javascript:void(showInstr())";
	aToggle.removeChild(aToggle.lastChild);
	aToggle.appendChild(document.createTextNode("Click here for instructions"));
}