// JavaScript Document
var checkedResults = new Array();
var senSlope; // Sen slope estimate
var senB; // Y-intercept for the sen slope line
var pValue; // for Mann-Kendall test for trend
var countiesArray = new Array();
var FIPSvalue;


$( document ).ready(function() {
	if (!Array.prototype.indexOf) { 
		Array.prototype.indexOf = function(obj, start) {
			 for (var i = (start || 0), j = this.length; i < j; i++) {
				 if (this[i] === obj) { return i; }
			 }
			 return -1;
		}
	}
	
	// initialize popups
	$(".dialog").dialog({
	    closeOnEscape: true,
        modal: true,
        position: [50,100],
		resizable: false,
		autoOpen: false  ///added this line
	}); 
	
	// initialize pop up sizes
	$("#usetDialog").dialog( "option", "width", 550 );
	
	$( "#Tabs1" ).tabs(); 
	$("div.ui-tabs-panel").css('padding','0px');
	
	$("#usetBtn").on("click", function(){$("#usetDialog").dialog("open")});
	$("#submitUsetTaskBtn").on("click", submitUsetData);
	
	$("#RadioSpatial_Map").on("click", function(){
		document.getElementById("textCountyTable").style.display = 'none';	
		document.getElementById("drawingToolsDisplay").style.display = '';	
	});
	
	$("#RadioSpatial_Text").on("click", function(){
		document.getElementById("textCountyTable").style.display = '';
		document.getElementById("drawingToolsDisplay").style.display = 'none';	
	});
	
	updateParameter();
	
	loadCounties();

	//$("#usetDialog").dialog("close");
	
});

function submitUsetData(){
	
	var stateCode = FIPSvalue.substr(0,2);
	var countyCode = FIPSvalue.substr(2,3);
	
	// url:'http://www.waterqualitydata.us/Result/search?countycode=US%3A40%3A109&characteristicName=Lead&sampleMedia=Water&mimeType=xml',
	  // http://www.waterqualitydata.us/Result/search?countycode=US%3A40%3A109&characteristicName=Phosphorus&sampleMedia=Water&siteType=Aggregate%20surface-water-use;Lake,%20Reservoir,%20Impoundment;Other-Surface%20Water;%20Stream&mimeType=xml
	  //url:'http://www.waterqualitydata.us/Result/search?countycode=US%3A' + stateCode + '%3A' + countyCode + '&characteristicName=' + $("#parameterSelect").val() + '&sampleMedia=Water&mimeType=xml',
	
	//var queryURL = 'http://www.waterqualitydata.us/Result/search?countycode=US%3A' + stateCode + '%3A' + countyCode + '&characteristicName=' + $("#parameterSelect").val() + '&sampleMedia=Water&siteType=Aggregate%20surface-water-use;Lake,%20Reservoir,%20Impoundment;Other-Surface%20Water;%20Stream&mimeType=xml'; 
	var queryURL = 'http://www.waterqualitydata.us/Result/search?countycode=US%3A' + stateCode + '%3A' + countyCode + '&characteristicName=' + $("#parameterSelect").val() + '&sampleMedia=Water&mimeType=xml';
	
	
	//$("#xmlOutput").val('http://www.waterqualitydata.us/Result/search?countycode=US%3A' + stateCode + '%3A' + countyCode + '&characteristicName=' + $("#parameterSelect").val() + '&sampleMedia=Water&mimeType=xml');
 
 $.ajax( {
       type:'GET',
       dataType:'xml',
	   timeout:60000,
       url: queryURL,
	  
	   success:function(data) {
	   document.getElementById("xmlQuery").innerHTML = "Query: " + queryURL;
	   $("#xmlOutput").val(new XMLSerializer().serializeToString(data));
       
		if (window.DOMParser)
		{
			parser = new DOMParser();
			xmlDoc = parser.parseFromString(new XMLSerializer().serializeToString(data),"text/xml");
		}
	  	else // Internet Explorer
		{
			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = false;
			xmlDoc.loadXML(new XMLSerializer().serializeToString(data));	
		}
		
		 loadResultsTable();
		 $( "#Tabs1" ).tabs( "option", "active", 1 );
     },
	 beforeSend:function(){
        // show gif here, eg:
        $("#loading").show();
    },
    complete:function(){
        // hide gif here, eg:
        $("#loading").hide();
    },
	 error:function(t){
        // show gif here, eg:
        $("#loading").hide();
		alert("Unable to connect to water quality data.\nQuery: " + queryURL);
		document.getElementById("xmlQuery").innerHTML = "Query Attempt: " + queryURL;
    }
   } );
   
   

}

function loadResultsTable()
{
	var row;
	var cell;
	var dateSplit = new Array();
	var date = new Date();
	var startDate = new Date();
	var endDate = new Date();
	var count = 0;
	
	startDate.setFullYear(1900,0,1);
	
	//if($("#beginDateInput").val() != "")
	//{
	//	startDate = new Date($("#beginDateInput").val());
	//}
	
	//if($("#endDateInput").val() != "")
	//{
	//	endDate = new Date($("#endDateInput").val());
	//}
	
	$(".resultCheck").off();
	
	while(document.getElementById("resultsTable").rows.length > 1)
	{
		document.getElementById("resultsTable").deleteRow(1);
	}
	
	for (var i = 0; i < xmlDoc.getElementsByTagName("Activity").length; i++) {
		if(xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasureValue")[0] != null)
		{
			date = new Date(xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityStartDate")[0].childNodes[0].nodeValue)
			
			if (date >= startDate && date <= endDate) {
				count = count + 1;
			
				row = document.getElementById("resultsTable").insertRow(document.getElementById("resultsTable").rows.length);
				
				cell = row.insertCell(0);
				cell.innerHTML = '<input id="resultCheck' + count + '" class="resultCheck" type="checkbox">';
				
				cell = row.insertCell(1);
				cell.innerHTML = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityStartDate")[0].childNodes[0].nodeValue;
				

				cell = row.insertCell(2);
				cell.innerHTML = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("ResultMeasureValue")[0].childNodes[0].nodeValue + " " + xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("MeasureUnitCode")[0].childNodes[0].nodeValue;

				

				cell = row.insertCell(3);
				cell.innerHTML = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityDescription")[0].getElementsByTagName("MonitoringLocationIdentifier")[0].childNodes[0].nodeValue;

				alert(xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("ResultMeasureValue")[0].childNodes[0].nodeValue);
			}
		}
	}
	
	$(".resultCheck").on("change", resultChecked);
	
}



function loadCounties()
{
    var tempObject;
    var splitString;

    for (var i = 0; i < fipsData.length; i++) {
       
        splitString = fipsData[i].toString().split(",");

        if (splitString.length == 3) {
            tempObject = new Object();

            tempObject.fips = splitString[0];
            tempObject.state = splitString[1];
            tempObject.county = splitString[2].substr(1, splitString[2].length);

            countiesArray.push(tempObject);
        }
    }

    loadStatesSelect();
    loadCountiesSelect();
 
   /* $.getJSON("Scripts/json/FipsCountyCodes.json", function (data) {
 		var tempObject;
		var splitString;
		
        for (var i = 0; i < data.table.rows.length; i++) {
			
			splitString = data.table.rows[i].toString().split(",");
			
			if (splitString.length == 3) {
				tempObject = new Object();
				
				tempObject.fips = splitString[0];
				tempObject.state = splitString[1];
				tempObject.county = splitString[2].substr(1, splitString[2].length);
				
				countiesArray.push(tempObject);
			}
        } 
		
		loadStatesSelect();
		loadCountiesSelect();
    }).error(function (e) { alert(e.responseText); });*/
}

function loadStatesSelect()
{
	var states = new Array();
	
	var selectString = '<select id="stateSelect">';
	
	for(var i=0; i<countiesArray.length; i++)
	{
		if(states.indexOf(countiesArray[i].state) == -1)
		{
			selectString += '<option value="' + countiesArray[i].state + '">' + countiesArray[i].state + '</option>'
			states.push(countiesArray[i].state);
		}
	}
	
	selectString += '</select>';
	
	document.getElementById("stateSelectWrapper").innerHTML = selectString;
	document.getElementById("stateSelect").selectedIndex = 0;
	$("#stateSelect").on("change", loadCountiesSelect);
	
}

function loadCountiesSelect()
{	
	var selectString = '<select id="countySelect" style="width:250px;">';
	var firstCounty = true;
	
	$("#countySelect").off();
	
	for(var i=0; i<countiesArray.length; i++)
	{
		if(countiesArray[i].state == $("#stateSelect").val())
		{
			selectString += '<option value="' + countiesArray[i].fips + '">' + countiesArray[i].county + '</option>'
				
			if(firstCounty == true)
			{
				FIPSvalue = countiesArray[i].fips;
				document.getElementById("fipsDisplay").innerHTML  = FIPSvalue;	
				firstCounty = false;
			}				
		}
	}
	
	selectString += '</select>';
	
	document.getElementById("countySelectWrapper").innerHTML = selectString;
	document.getElementById("countySelect").selectedIndex = 0;
		
	
	$("#countySelect").on("change", function(){
		FIPSvalue = $("#countySelect").val();
		document.getElementById("fipsDisplay").innerHTML  = FIPSvalue;
	});
}

function updateParameter()
{
	$(".selectedWaterParameter").html($("#parameterSelect option:selected").text());
	
}

function resultChecked()
{
	var tempObject;
	
	checkedResults = new Array();

	for(var i=1, len=document.getElementById("resultsTable").rows.length; i<len; i++)
	{	
		if(document.getElementById("resultCheck" + i).checked == true)
		{
			tempObject = new Object();
			
			tempObject.date = document.getElementById("resultsTable").rows[i].cells[1].innerHTML;	
			tempObject.value = document.getElementById("resultsTable").rows[i].cells[2].innerHTML;	
			
			checkedResults.push(tempObject);
		}
		
	}

	if(checkedResults.length >= 2)
	{
		handleTrends();	
	}
	else
	{
		senSlope = 0; 
		senB = 0;
		pValue = 0;
	}
	
	drawChart();
}

function median(values) 
{

        values.sort(function(a, b) {
            return a - b;
        });

        var half = Math.floor(values.length / 2);

        if (values.length % 2) return values[half];
        else return (values[half - 1] + values[half]) / 2.0;
}

// from http://stackoverflow.com/questions/16194730/seeking-a-statistical-javascript-function-to-return-p-value-from-a-z-score

function GetZPercent(z) {
	//z == number of standard deviations from the mean

	//if z is greater than 6.5 standard deviations from the mean
	//the number of significant digits will be outside of a reasonable 
	//range
	if (z < -6.5) return 0;
	if (z > 6.5) return 1;

	var factK = 1;
	var sum = 0;
	var term = 1;
	var k = 0;
	var loopStop = Math.exp(-23);
	while (Math.abs(term) > loopStop) {
		term = .3989422804 * Math.pow(-1, k) * Math.pow(z, k) / (2 * k + 1) / Math.pow(2, k) * Math.pow(z, k + 1) / factK;
		sum += term;
		k++;
		factK *= k;

	}
	sum += 0.5;

	return sum;
}

function handleTrends()
{
	// http://pubs.usgs.gov/twri/twri4a3/html/toc.html good resource
	//   var myArray;
	
	var mySlopeArray = [];
	var mySlopeArraySort = [];
	var myBArray = [];
	
	var myDiff;
	var myDiv;
	
	var posSlope = 0;
	var negSlope = 0;
	var numTied = 0;
	
	var varS;
	var Zcrit = 1.645; //  when  90% Confidence Interval (CI), use Zcrit=1.645; when 95% CI is desired use Zcrit=1.96
	var cAlpha;
	var nPrime;
	
	var senSlopeLower; // when Zcrit=1.645 it is lower 90% Confidence Interval of Sen Slope
	var senSlopeUpper; // when Zcrit=1.645 it is upper 90% Confidence Interval of Sen Slope
	var M1;
	var M2;
	
	var S; // for Mann-Kendall test for trend if S< 0 downward trend; if S>0 upward trend; S=0 no trend
	var Z; // for Mann-Kendall test for trend
	
	var splitResult;
	
	var myArray = new Array();
	var myDateArray = new Array();
	
	for(var i=0; i<checkedResults.length; i++)
	{
		splitResult = checkedResults[i].value.split(" ");
		
		myArray.push(Number(splitResult[0]));	
		myDateArray.push(checkedResults[i].date);		
	}
	
	
	// var one;
    // var two;
    // one = parseDate(myDateArray[0]);
    // two = parseDate(myDateArray[1]);
    // parseDate(myDateArray[i]);
    // parseDate(myDateArray[j]);
    // var three;
    // three = daydiff(one, two);

    for (var j = 0; j < myArray.length - 1; j++) {
        for (var i = 1; i < myArray.length; i++) {
            if (j < i) {
                myDiff = (myArray[i] - myArray[j]);
                //       myDiv = (myArray[i] - myArray[j]) / (i - j);
              //  document.write("<br><br> between " + myDateArray[j] + " and " + myDateArray[i] + " is =" + (daydiff(parseDate(myDateArray[j]), parseDate(myDateArray[i]))));
                myDiv = (myArray[i] - myArray[j]) / (daydiff(parseDate(myDateArray[j]), parseDate(myDateArray[i])));
                mySlopeArray.push(myDiv);


                if (myDiv > 0) {
                    posSlope = posSlope + 1;
                } else if (myDiv < 0) {
                    negSlope = negSlope + 1;
                } else {
                    numTied = numTied + 1;
                }
            //    document.write("<br> i-j=" + (i - j) + " Elements: " + myArray[i] + " - " + myArray[j] + " = " + myDiff + " Slope =" + myDiv);


            }
        }
    }

    mySlopeArraySort = mySlopeArray.sort(function(a, b) {
        return a - b;
    });

    //Mann Kendall test for trends
    S = posSlope - negSlope;

    varS = (myArray.length * (myArray.length - 1) * (2 * myArray.length + 5) / 18);
    // varS could add the number of tied values to make it better you would add http://www.webapps.cee.vt.edu/ewr/environmental/teach/smprimer/sen/sen.html
    //varS = 211.67

    // sen estimate of slope is the median of all calculated slopes
    senSlope = median(mySlopeArray);

    // now get the y-intercept
    for (var i = 0; i < myArray.length; i++) {
        myBArray.push(myArray[i] - senSlope * i);
    }

    senB = median(myBArray);

    // calculate Z statistic and get Pvalue
    // From MAKESENS 1.0
    if (S > 0) {
        Z = (S - 1) / Math.pow(varS, .5);
    } else if (S < 0) {
        Z = (S + 1) / Math.pow(varS, .5);
    } else {
        Z = 0;
    }
    // End from MAKESENS 1.0
    pValue = GetZPercent(Z);

    // calculate the Upper/Lower Confidence Intervals around Sen Slope
    cAlpha = Zcrit * Math.pow(varS, .5);
    nPrime = mySlopeArray.length;
    M1 = (nPrime - cAlpha) / 2;
    M2 = (nPrime + cAlpha) / 2;
    // From MAKESENS 1.0
    M1F = mySlopeArraySort[Math.floor(M1)];
    M1F1 = mySlopeArraySort[Math.floor(M1) + 1];
    senSlopeLower = M1F + (M1 - Math.floor(M1)) * (M1F1 - M1F);
    senSlopeUpper = mySlopeArraySort[Math.floor(M2)] + (M2 + 1 - Math.floor(M2)) * (mySlopeArraySort[Math.floor(M2) + 1] - mySlopeArraySort[Math.floor(M2)]);
    // End from MAKESENS 1.0

    //  If senSlopeLower > 0 AND senSlopeUpper > 0 or  senSlopeLower < 0 AND senSlopeUpper < 0 then slope is non-zero
    //  at the Confidence Interval from the Zcrit selected above (e.g. 90% or 95% depending on value of Zcrit

    //document.write("<br><br> The calculated Slope Array <br>" + mySlopeArray);
    //document.write("<br><br> The calculated B Array <br>" + myBArray);
    //document.write("<br><br> The sorted calculated Slope Array <br>" + mySlopeArraySort);
    //document.write("<br><br> The S = " + S);
    //document.write("<br><br> The Variance(s) =   " + varS);
    //document.write("<br><br> The cAlpha = " + Zcrit + " * "+ Math.pow(varS, .5) + " = " + cAlpha);
    //document.write("<br><br> The Z = " + Z);
    //document.write("<br><br> The pValue = " + pValue);
    //document.write("<br><br> The N Prime = " + nPrime);
    //document.write("<br><br> The M1 = " + M1);
    //document.write("<br><br> The M1F = " + M1F);
    //document.write("<br><br> The M1F + 1 = " + M1F1);

    //document.write("<br><br> The senSlopeLower = " + senSlopeLower);


    //document.write("<br><br> The M2 = " + M2);
    //document.write("<br><br> The senSlopeLower = " + senSlopeLower);
    //document.write("<br><br> The senSlopeUpper = " + senSlopeUpper);
}

// Callback that creates and populates a data table,
// instantiates the pie chart, passes in the data and
// draws it.
function drawChart() 
{
	var data = new google.visualization.DataTable();
	
	var splitResult;
	var splitDate;
	var x;

  // Declare columns
  data.addColumn('date', 'Date');
  data.addColumn('number', 'Measured Value');
  data.addColumn('number', 'Trend');
  

  for(var i=0; i<checkedResults.length; i++)
  {
	  splitResult = checkedResults[i].value.split(" ");
	  splitDate = checkedResults[i].date.split("-");
	  
	  x = daydiff(parseDate(checkedResults[0].date), parseDate(checkedResults[i].date));
	  
	 // data.addRow([{v:i+1,f: checkedResults[i].date}, Number(splitResult[0]),(senSlope*(i+1) + senB)]);
	data.addRow([new Date(splitDate[0], splitDate[1]-1, splitDate[2]), Number(splitResult[0]),(senSlope*(x) + senB)]);
	//data.addRow([splitDate[1] + "/" + splitDate[2]+ "/" + splitDate[2]), Number(splitResult[0]),(senSlope*(x) + senB)]);
  }
  
  
  // var data = google.visualization.arrayToDataTable([
  // ['Date', 'Measured Value'],
  // [8, 37], [4, 19.5], [11, 52], [4, 22], [3, 16.5], [6.5, 32.8], [14, 72]]);
  
  //data.addRow([mymap[i], 1, 6, mymapcount[i], 6]);
  
  var options = {
	  title: 'USET Trend',
	 // chartArea: {'width': '67%', 'height': '60%'},
	  hAxis: {title: 'Date', format: 'M/yy'},
	  vAxis: {title: 'Measured Value'},
	  legend: 'none',
	  
	 series: {0:{lineWidth:0, pointSize:5, visibleInLegend: false}, 1:{lineWidth:1, pointSize:0, visibleInLegend: false}},

  };
  
  
  var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
  chart.draw(data, options);
  
  $(".pvalue").html(pValue.toFixed(4));
  $(".slope").html(senSlope.toFixed(4));
  $(".intercept").html(senB.toFixed(4));
}

function parseDate(str)
{
     var mdy = str.split('-')
     return new Date(mdy[0], mdy[1] - 1, mdy[2]);
}

function daydiff(first, second) 
{
     return Math.floor((second - first) / (1000 * 60 * 60 * 24))
}
