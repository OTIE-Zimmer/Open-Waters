// JavaScript Document


var checkedResults = new Array();
var senSlope; // Sen slope estimate
var senB; // Y-intercept for the sen slope line
var pValue; // for Mann-Kendall test for trend
var countiesArray = new Array();
var FIPSvalue;
var lowThresh;
var highThresh;
var queryResults;
var selectedParameter;

$(document).ready(function () {
    // allow use of array indexOf in IE
    if (!Array.prototype.indexOf) {
        Array.prototype.indexOf = function (obj, start) {
            for (var i = (start || 0), j = this.length; i < j; i++) {
                if (this[i] === obj) { return i; }
            }
            return -1;
        }
    }
 
    // function that allows comparison of arrays
    Array.prototype.compare = function (array) {
        // if the other array is a falsy value, return
        if (!array)
            return false;

        // compare lengths - can save a lot of time
        if (this.length != array.length)
            return false;

        for (var i = 0, l = this.length; i < l; i++) {
            // Check if we have nested arrays
            if (this[i] instanceof Array && array[i] instanceof Array) {
                // recurse into the nested arrays
                if (!this[i].compare(array[i]))
                    return false;
            }
            else if (this[i] != array[i]) {
                // Warning - two different object instances will never be equal: {x:20} != {x:20}
                return false;
            }
        }
        return true;
    }

    // date pickers
 
        $("#beginDateInput").datepicker();

        $("#endDateInput").datepicker();
  
    /*
    $("#beginDateInput").datepicker({ changeMonth: true, changeYear: true });

    $("#endDateInput").datepicker({ changeMonth: true, changeYear: true });
    */
   
    // load tabs
    //$("#SearchAnalyzeNav").tabs();
    
    //$("#submitUsetTaskBtn").on("click", submitUsetData);
    
    // radio listeners
        $("#RadioAnalyze_box").on("click", function () {
            document.getElementById("analyzeTrendsArea").style.display = 'none';
            document.getElementById("analyzeBoxArea").style.display = '';
    });

        $("#RadioAnalyze_trends").on("click", function () {
            document.getElementById("analyzeTrendsArea").style.display = '';
            document.getElementById("analyzeBoxArea").style.display = 'none';
    });
    

        $("#checkAllBtn").on("click", function () {
            for (var i = 0; i < queryResults.length; i++) {
                for (var j = 0; j < queryResults[i].data.length; j++) {
                    document.getElementById("resultCheck" + i + "_" + j).checked = true;
                }
            }
            
            //$(".resultCheck").attr('checked', true);
            resultChecked();

        })

        $("#uncheckAllBtn").on("click", function () {
            for (var i = 0; i < queryResults.length; i++) {
                for (var j = 0; j < queryResults[i].data.length; j++) {
                    document.getElementById("resultCheck" + i + "_" + j).checked = false;
                }
            }
            //$(".resultCheck").attr('checked', false);
        resultChecked();

    })

    
    
});

function setThreshold()
{
    generateBoxWhisker();
    resultChecked();
}

function generateBoxWhisker()
{
    var locationsArray = [];
    var outlierArray = [];
    var dataArray = [];
    for (var i = 0; i < checkedResults.length; i++) {
        var max, min, median, upperQuartile, lowerQuartile;
        var valueArray = [];
        var unit = checkedResults[i].data[0].unit;
        for (var j = 0; j < checkedResults[i].data.length; j++) {
            valueArray[j] = checkedResults[i].data[j].value;
        }
        var sortedArray = valueArray.sort(function (a, b) { return a - b });
        max = sortedArray[sortedArray.length - 1];
        min = sortedArray[0];
        
        if (sortedArray.length % 2 == 0) {//even
            median = (sortedArray[sortedArray.length / 2] + sortedArray[(sortedArray.length / 2) - 1]) / 2;
        } else {
            median = sortedArray[parseInt(sortedArray.length / 2)];
        }
        var upperQuartileArray = []; 
        var lowerQuartileArray = [];
        for (var j = 0; j < sortedArray.length; j++) {
            if (sortedArray[j] > median) {
                upperQuartileArray[upperQuartileArray.length] = sortedArray[j];
            }
            if (sortedArray[j] < median) {
                lowerQuartileArray[lowerQuartileArray.length] = sortedArray[j];
            }
        }
        if (upperQuartileArray.length % 2 == 0) {//even
            upperQuartile = (upperQuartileArray[upperQuartileArray.length / 2] + upperQuartileArray[(upperQuartileArray.length / 2) - 1]) / 2;
        } else {
            upperQuartile = upperQuartileArray[parseInt(upperQuartileArray.length / 2)];
        }

        if (lowerQuartileArray.length % 2 == 0) {//even
            lowerQuartile = (lowerQuartileArray[lowerQuartileArray.length / 2] + lowerQuartileArray[(lowerQuartileArray.length / 2) - 1]) / 2;
        } else {
            lowerQuartile = lowerQuartileArray[parseInt(lowerQuartileArray.length / 2)];
        }

        for (var o = 1; o < sortedArray.length -1; o++) { //I'm excluding the min and max values
            if (sortedArray[o] < lowerQuartile || sortedArray[o] > upperQuartile) {
                outlierArray[outlierArray.length] = [locationsArray.length, sortedArray[o]];
            }
        }
        

        locationsArray[locationsArray.length] = checkedResults[i].location;
        dataArray[dataArray.length] = [min, lowerQuartile, median, upperQuartile, max];
        //console.log(checkedResults[i].location);
        //console.log(min);
        //console.log(lowerQuartile);
        //console.log(median);
        //console.log(upperQuartile);
        //console.log(max);
    }
    var chart1 = new Highcharts.Chart({
        chart: {
            renderTo: 'boxWhiskerPlot',
            type: 'boxplot',
            
        },
        title: {
            text: ''
        },
        xAxis: {
            categories: locationsArray,
            title: {
                text: 'Monitoring Site.'
            }
        },
        yAxis: {
            title: {
                text: 'Observations (' + unit + ')'
            },
            plotLines: [{
                value: $("#upperThreshChartsInput").val(),
                color: '#ff9900',
                width: 2,
                label: {
                    text: 'Upper Threshold:' + $("#upperThreshChartsInput").val(),
                    align: 'center',
                    style: {
                        color: 'gray'
                    }
                }
            },
            {
                value: $("#lowThreshChartsInput").val(),
                color: '#dc3912',
                width: 2,
                label: {
                    text: 'Lower Threshold:' + $("#lowThreshChartsInput").val(),
                    align: 'center',
                    style: {
                        color: 'gray'
                    }
                }
            }]
        },
        series: [{
            name: 'Observations (' + unit + ')',
            data: dataArray,
            tooltip: {
                headerFormat: '<em>Monitoring Site: {point.key}</em><br/>'
            }
        }, {
            name: 'Outlier',
            color: Highcharts.getOptions().colors[0],
            type: 'scatter',
            data: outlierArray,
            marker: {
                fillColor: 'white',
                lineWidth: 1,
                lineColor: Highcharts.getOptions().colors[0]
            },
            tooltip: {
                pointFormat: 'Observation: {point.y}'
            }
        }]
    });
    chart1.reflow();
//    var margin = { top: 10, right: 50, bottom: 20, left: 50 },
//    width = 120 - margin.left - margin.right,
//    height = 500 - margin.top - margin.bottom;
//
//    var labels = true; // show the text labels beside individual boxplots?
//    
//    var min = Infinity,
//        max = -Infinity;
//    
//    var chart = d3.box()
//        .whiskers(iqr(1.5))
//        .width(width)
//        .height(height);
//        //.showLabels(labels);
//
//    var row;
//    var cell;
//
//    var data = [];
//    var e, s, d;
//    
//   /* for (var i = 0; i < checkedResults.length; i++) {
//        data[i] = [];
//        data[i][0] = checkedResults.location;
//        data[i][1] = [];
//
//        for (var j = 0; j < checkedResults[i].data.length; j++) {
//            data[i][1].push(checkedResults[i].data[j].value);
//        }
//
//    }*/
//
//    for (var i = 0; i < checkedResults.length; i++) {
//
//        for (var j = 0; j < checkedResults[i].data.length; j++)
//        {
//            d = data[i];
//
//            if (!d) {
//                d = data[i] = [checkedResults[i].data[j].value];
//
//                row = document.getElementById("analyzeBoxXAxis").insertRow(document.getElementById("analyzeBoxXAxis").rows.length);
//
//                cell = row.insertCell(0);
//                cell.style.textAlign = "left";
//                cell.innerHTML = document.getElementById("analyzeBoxXAxis").rows.length + ". " + checkedResults[i].location;
//            }
//            else {
//                d.push(checkedResults[i].data[j].value);
//            }
//
//            
//            if (checkedResults[i].data[j].value > max) {
//                max = checkedResults[i].data[j].value;
//            }
//
//
//            if (checkedResults[i].data[j].value < min) {
//                min = checkedResults[i].data[j].value;
//            }
//        }
//
//    }
//
//
//    chart.domain([min, max]);
//
//       var svg = d3.select("#boxWhiskerPlot").selectAll("svg")
//            .data(data)
//          .enter().append("svg")
//            .attr("class", "box")
//            .attr("width", width + margin.left + margin.right)
//            .attr("height", height + margin.bottom + margin.top)
//          .append("g")
//            .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
//            .call(chart);
//            
    /*
    // the x-axis
       var x = d3.scale.ordinal()
           .domain(data.map(function (d) { console.log(d); return d[0] }))
           .rangeRoundBands([0, width], 0.7, 0.3);

       var xAxis = d3.svg.axis()
           .scale(x)
           .orient("bottom");

    // draw the boxplots	
    d3.select("#boxWhiskerPlot").selectAll("svg")
         .data(data)
         .enter().append("g")
           .attr("transform", function (d) { return "translate(" + x(d[0]) + "," + margin.top + ")"; })
         .call(chart.width(x.rangeBand()));

    // draw x axis	
       svg.append("g")
         .attr("class", "x axis")
         .attr("transform", "translate(0," + (height + margin.top + 10) + ")")
         .call(xAxis)
         .append("text")             // text label for the x axis
           .attr("x", (width / 2))
           .attr("y", 10)
           .attr("dy", ".71em")
           .style("text-anchor", "middle")
           .style("font-size", "16px")
           .text("Quarter");
        
        */
}

// Returns a function to compute the interquartile range.
function iqr(k) {
    return function (d, i) {
        var q1 = d.quartiles[0],
            q3 = d.quartiles[2],
            iqr = (q3 - q1) * k,
            i = -1,
            j = d.length;
        while (d[++i] < q1 - iqr);
        while (d[--j] > q3 + iqr);
        return [i, j];
    };
}

function updateParameter() {
    selectedParameter = $("#parameterSelect option:selected").text();
    $(".selectedWaterParameter").html(selectedParameter);

}



function submitUsetData() {

    //var stateCode = FIPSvalue.substr(0, 2);
   // var countyCode = FIPSvalue.substr(2, 3);

    //var queryURL = 'http://www.waterqualitydata.us/Result/search?characteristicName=' + $("#parameterSelect").val() + '&sampleMedia=Water&mimeType=xml';
    var queryURL = 'http://www.waterqualitydata.us/Result/search?sampleMedia=Water&mimeType=xml';
    if ($("#allOrganizationShown").val() != 'true') {
        queryURL += '&organization=' + $("#parameterOrganization").val()
    }
    if ($("#parameterSiteIDs").val() != '') {
        queryURL += '&siteid=' + $("#parameterSiteIDs").val()
    }else if ($("#parameterBBox").val() != '') {
        queryURL += '&bBox=' + $("#parameterBBox").val()
    } 
    else {
        queryURL += '&within=1&lat=' + $("#latInput").val() + '&long=' + $("#longInput").val();
    }

    if ($("#beginDateInput").val() != '') {
        queryURL += '&startDateLo=' + $("#beginDateInput").val().replace("/", "-").replace("/", "-") + '&startDateHi=' + $("#endDateInput").val().replace("/", "-").replace("/", "-");
    }
    
        
    document.getElementById("searchQueryDisplay").innerHTML = queryURL;

    clearAllCharts();
    
    $.ajax({
        type: 'GET',
        dataType: 'xml',
        timeout: 60000,
        url: queryURL,

        success: function (data) {
           // document.getElementById("xmlQuery").innerHTML = "Query: " + queryURL;
           // $("#xmlOutput").val(new XMLSerializer().serializeToString(data));

            if (window.DOMParser) {
                parser = new DOMParser();
                xmlDoc = parser.parseFromString(new XMLSerializer().serializeToString(data), "text/xml");
            }
            else // Internet Explorer
            {
                xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
                xmlDoc.async = false;
                xmlDoc.loadXML(new XMLSerializer().serializeToString(data));
            }
         
            updateParameter();

            lowThresh = -Infinity;
            highThresh = Infinity;

            if ($("#lowThreshInput").val() != "") {
                lowThresh = parseFloat($("#lowThreshInput").val());
            }

            if ($("#highThreshInput").val() != "") {
                highThresh = parseFloat($("#highThreshInput").val());
            }

            loadResultsTable();
        },
        beforeSend: function () {
            // show gif here, eg:

            // clear results table
            /*while (document.getElementById("resultsTable").rows.length > 1) {
                document.getElementById("resultsTable").deleteRow(1);
            }*/
            document.getElementById("accordion").innerHTML = "";
            
            $("#loading").show();
            document.body.style.cursor = "progress";

        },
        complete: function () {
            // hide gif here, eg:
            $("#loading").hide();
            document.body.style.cursor = "default";
        },
        error: function (t) {
            // show gif here, eg:
            $("#loading").hide();
            document.body.style.cursor = "default";
            alert("Unable to connect to water quality data.\nQuery: " + queryURL);
            document.getElementById("xmlQuery").innerHTML = "Query Attempt: " + queryURL;
        }
    });

}

function loadResultsTable() {
    var row;
    var cell;
    var dateSplit = new Array();
    var date = new Date();
    var startDate = new Date();
    var endDate = new Date();
    var count = 0;
    var tempObject;
    var listIndex;

    queryResults = new Array();
    var siteList = new Array();

    startDate.setFullYear(1900, 0, 1);
    
    if ($("#beginDateInput").val() != "") {
        startDate = new Date($("#beginDateInput").val());
    }

    if ($("#endDateInput").val() != "") {
        endDate = new Date($("#endDateInput").val());
    }
    $(".resultCheck").off();

    /*while (document.getElementById("resultsTable").rows.length > 1) {
        document.getElementById("resultsTable").deleteRow(1);
    }*/
    document.getElementById("accordion").innerHTML = "";
  
    //characteristicName=' + $("#parameterSelect").val() + '&
    for (var i = 0; i < xmlDoc.getElementsByTagName("Activity").length; i++) {
        if (xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasureValue")[0] != null) {
            date = new Date(xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityStartDate")[0].childNodes[0].nodeValue)
            
            if (date >= startDate && date <= endDate) {
                var results = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("Result");
                for (var r = 0; r < results.length; r++) {
                    var characteristic = results[r].getElementsByTagName("CharacteristicName")[0].childNodes[0].nodeValue;

                    if (characteristic == $("#parameterSelect").val()) {
                        if (lowThresh <= parseFloat(xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("ResultMeasureValue")[0].childNodes[0].nodeValue) && highThresh >= parseFloat(xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("ResultMeasureValue")[0].childNodes[0].nodeValue)) {
                            listIndex = siteList.indexOf(xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityDescription")[0].getElementsByTagName("MonitoringLocationIdentifier")[0].childNodes[0].nodeValue);

                            if (listIndex == -1) {
                                siteList.push(xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityDescription")[0].getElementsByTagName("MonitoringLocationIdentifier")[0].childNodes[0].nodeValue);

                                tempObject = new Object();
                                tempObject.location = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityDescription")[0].getElementsByTagName("MonitoringLocationIdentifier")[0].childNodes[0].nodeValue;
                                tempObject.data = new Array();

                                queryResults.push(tempObject);

                                listIndex = siteList.length - 1;


                            }

                            tempObject = new Object();

                            if (xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityStartDate")[0].childNodes[0] != null) {
                                tempObject.date = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityStartDate")[0].childNodes[0].nodeValue;
                            }

                            if (results[r].getElementsByTagName("MeasureUnitCode")[0] != null) {
                                tempObject.unit = results[r].getElementsByTagName("MeasureUnitCode")[0].childNodes[0].nodeValue;
                            }

                            if (results[r].getElementsByTagName("ResultMeasureValue")[0] != null) {
                                tempObject.value = results[r].getElementsByTagName("ResultMeasureValue")[0].childNodes[0].nodeValue;
                                queryResults[listIndex].data.push(tempObject); //we only want to include values where it's not null
                            }
                            
                    }
                }
                

                    /*count = count + 1;

                    row = document.getElementById("resultsTable").insertRow(document.getElementById("resultsTable").rows.length);

                    cell = row.insertCell(0);
                    cell.innerHTML = '<input id="resultCheck' + count + '" class="resultCheck" type="checkbox">';

                    cell = row.insertCell(1);

                    if (xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityStartDate")[0].childNodes[0] != null) {
                        cell.innerHTML = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityStartDate")[0].childNodes[0].nodeValue;
                    }

                    cell = row.insertCell(2);

                    if (xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("ResultMeasureValue")[0] != null) {
                        cell.innerHTML = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("ResultMeasureValue")[0].childNodes[0].nodeValue;
                    }

                    cell = row.insertCell(3);

                    if (xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("MeasureUnitCode")[0] != null) {
                        cell.innerHTML = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ResultMeasure")[0].getElementsByTagName("MeasureUnitCode")[0].childNodes[0].nodeValue;
                    }

                    cell = row.insertCell(4);

                    if (xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityDescription")[0].getElementsByTagName("MonitoringLocationIdentifier")[0] != null) {
                        cell.innerHTML = xmlDoc.getElementsByTagName("Activity")[i].getElementsByTagName("ActivityDescription")[0].getElementsByTagName("MonitoringLocationIdentifier")[0].childNodes[0].nodeValue;
                    }*/
                }
                
                
            }
        }
    }

    for (var i = 0; i < queryResults.length; i++)
    {
        var panelDiv = $("<div/>")   // creates a div element
                 .attr("id", "panelDiv" + i)  // adds the id
                 .addClass("panel")   // add a class
				 .addClass("panel-default");   // add a class

        $("#accordion").append(panelDiv);

        var panelHeading = $("<div/>")   // creates a div element
                 .attr("id", "panelHeadDiv" + i)  // adds the id
                 .addClass("panel-heading")   // add a class
				 .html('<h4 class="panel-title"><a data-toggle="collapse" href="#collapse' + i + '">' + queryResults[i].location + '</a></h4>');

        $("#panelDiv" + i).append(panelHeading);

        var panelExpand = $("<div/>")   // creates a div element
                 .attr("id", "collapse" + i)  // adds the id
                 .addClass("panel-collapse")   // add a class
                 .addClass("collapse")   // add a class
                 //.addClass("in")   // add a class
				 .html('<div class="panel-body"></div>');

        $("#panelDiv" + i).append(panelExpand);
  

        var table = document.createElement("table");
        var row;
        var cell;


        row = table.insertRow(0);
        cell = row.insertCell(0);
        cell.width = 50;
        cell = row.insertCell(1);
        cell.width = 100;
        cell.innerHTML = "<b>Date</b>";
        cell = row.insertCell(2);
        cell.width = 100;
        cell.innerHTML = "<b>Value</b>";
        cell = row.insertCell(3);
        cell.width = 100;
        cell.innerHTML = "<b>Unit</b>";

        for (var j = 0; j < queryResults[i].data.length; j++)
        {
            row = table.insertRow(j + 1);
            cell = row.insertCell(0);
            cell.innerHTML = '<input id="resultCheck' + i + '_' + j + '" class="resultCheck resultCheck' + i + '" type="checkbox">';
            cell = row.insertCell(1);
            cell.innerHTML = queryResults[i].data[j].date;
            cell = row.insertCell(2);
            cell.innerHTML = queryResults[i].data[j].value;
            cell = row.insertCell(3);
            cell.innerHTML = queryResults[i].data[j].unit;
        }

        
        $("#collapse" + i + " .panel-body").append('<button id="checkAllBtn' + i + '" value="' + i + '" type="button">Select All</button>' +
                    '<button id="deselectAllBtn' + i + '" value="' + i + '" type="button">Deselect All</button><br>');

        $("#collapse" + i + " .panel-body").append(table);

        $("#checkAllBtn" + i).on("click", function () {
            for (var j = 0; j < queryResults[$(this).val()].data.length; j++) {
                document.getElementById("resultCheck" + $(this).val() + "_" + j).checked = true;
            }

            //$(".resultCheck" + $(this).val()).attr('checked', true);
            resultChecked();
        });

        $("#deselectAllBtn" + i).on("click", function () {
            for (var j = 0; j < queryResults[$(this).val()].data.length; j++) {
                document.getElementById("resultCheck" + $(this).val() + "_" + j).checked = false;
            }
            //$(".resultCheck" + $(this).val()).attr('checked', false);
            resultChecked();
        });      
    }


    $(".resultCheck").on("click", resultChecked);

}

function resultChecked() {
    var tempObject;
    var locationList = new Array();
    var tempObject;

    clearAllCharts();

    checkedResults = new Array();
    for (var i = 0; i < queryResults.length; i++)
    {
               
        tempObject = new Object();
        tempObject.location = queryResults[i].location;
        tempObject.data = new Array();
           
        checkedResults.push(tempObject);
            
        for (var j = 0; j < queryResults[i].data.length; j++) {
            if (document.getElementById("resultCheck" + i + "_" + j).checked == true) {
                tempObject = new Object();
                tempObject.date = queryResults[i].data[j].date;
                tempObject.value = Number(queryResults[i].data[j].value);
                tempObject.unit = queryResults[i].data[j].unit;
               
                checkedResults[checkedResults.length-1].data.push(tempObject);
            }
        }
        
        // if nothing is checked, remove it
        if(checkedResults[checkedResults.length-1].data.length == 0)
        {
            checkedResults.pop();
        }
        
    }
    generateBoxWhisker();
    makeMasterChart();

    for (var i = 0; i < checkedResults.length; i++) {
        if (checkedResults[i].data.length >= 2) {
            handleTrends(checkedResults[i]);
        }
        else {
            senSlope = 0;
            senB = 0;
            pValue = 0;
        }
                
        drawChart(checkedResults[i], i);  
    }
}

function sortCheckedResults(a, b) {
    var num1 = parseInt(a.locationIndex);
    var num2 = parseInt(b.locationIndex);

    if (num1 < num2) {
        return -1;
    }
    if (num1 > num2) {
        return 1;
    }

    return 0;
}

function handleTrends(result) {
    // http://pubs.usgs.gov/twri/twri4a3/html/toc.html good resource
    var Zcrit
    var posSlope = 0;
    var negSlope = 0;
    var numTied = 0;

    var myDates = new Array();
    var myResultsArray = new Array();

    for (var i = 0; i < result.data.length; i++) { //Added by Chuck to populate Don's variables.
        myResultsArray.push(result.data[i].value);
        myDates.push(result.data[i].date);
    }
    if (myDates.length >= 5) //Five data point are required for trend analysis
    {
        var myArrayLength = [];
        for (var i = 0; i < myDates.length; i++) {
            myArrayLength.push(i);
        }
        var myDateDiff = [];
        var myResultsDiff = [];
        var mySlopeArray = [];
        var myBArray = [];
        var myPairedIndex = combinations(myArrayLength, 2);
        var MannK;
        var varS;
        var Zs;


        // sen estimate of slope is the median of all calculated slopes
        for (var i = 0; i < myPairedIndex.length; i++) {
            myIndex = myPairedIndex[i];
            firstIndex = myIndex[0];
            secondIndex = myIndex[1];
//            myDateDiff[i] = daydiff(parseDate(myDates[firstIndex]), parseDate(myDates[secondIndex]));
            myDateDiff[i] = daydiff(parseDate(myDates[secondIndex]), parseDate(myDates[firstIndex])); //this seems to correct the slope
            // myResultsDiff[i] = myResultsArray[firstIndex] - myResultsArray[secondIndex];
            myResultsDiff[i] = myResultsArray[secondIndex] - myResultsArray[firstIndex];
            mySlopeArray[i] = myResultsDiff[i] / myDateDiff[i];

            if (mySlopeArray[i] > 0) {
                posSlope = posSlope + 1;
            } else if (mySlopeArray[i] < 0) {
                negSlope = negSlope + 1;
            } else {
                numTied = numTied + 1;
            }
        }
        senSlope = median(mySlopeArray);
        // now get the y-intercept
        // sen estimate of intercepts is the median of all calculated intercepts through the points using the Sen slope

        //Math.min.apply(null, arr)

        senB = median(myResultsArray) - (senSlope * (myDateDiff.max() / 2));
        //Mann Kendall test for trends
        //If n<10, then use the lookup table, below, to determine the critical value of S for various values of n. 

        S = posSlope - negSlope;

        Scrit = 0;
        if (myDates.length <= 10) {
            switch (myDates.length) {
                case 5:
                    Scrit = 10
                    break;
                case 6:
                    Scrit = 13
                    break;
                case 7:
                    Scrit = 15
                    break;
                case 8:
                    Scrit = 18
                    break;
                case 9:
                    Scrit = 20
                    break;
                case 10:
                    Scrit = 23
                    break;
            }
            //  Now the actual test
            if (S >= Scrit) {
                MannK = "Sig. increasing";
                pValue = .01;
            } else if (S <= (-1 * Scrit)) {
                MannK = "Sig. decreasing";
                pValue = .01;
            } else {
                MannK = "No Trend";
                pValue = 2;
            }

        }
            //  If n>=10, then calculate variance of S and use the formula for the normal approximation of the probability of S
        else {
            varS = (myDates.length * (myDates.length - 1) * (2 * myDates.length + 5) / 18);
            //=IF(L26=0,0,IF(L26>0,(L26-1)/K30^0.5,(L26+1)/K30^0.5))
            if (S > 0) {
                Zs = (S - 1) / Math.sqrt(varS);
            } else if (S < 0) {
                Zs = (S + 1) / Math.sqrt(varS);
            } else {
                Zs = 0;
            }
            //  Now the actual test
            Zcrit = 1.96; //  1.96 (positive or negative) is the critical value for Z, two-tailed, at p < .05

            if (Zs >= Zcrit) {
                MannK = "Sig. increasing";
                pValue = .01; //Update global variable to show it IS significant
            } else if (Zs <= (-1 * Zcrit)) {
                MannK = "Sig. decreasing";
                pValue = .01; //Update global variable to show it IS significant
            } else {
                MannK = "No Trend";
                pValue = 2; //Update global variable to show it is NOT significant
            }

        }
        //console.log(S);
        //console.log(Zs);
        //console.log(MannK);
        //console.log(pValue);
        //End Don's code
    }    
}


function combinations(arr, size) {
    var len = arr.length;
    if (size > len) return [];
    if (!size) return [[]];
    if (size == len) return [arr];
    return arr.reduce(function (acc, val, i) {
        var res = combinations(arr.slice(i + 1), size - 1)
            .map(function (comb) {
                return [val].concat(comb);
            });
        return acc.concat(res);
    }, []);
}

Array.prototype.max = function () {
    return Math.max.apply(null, this);
};

Array.prototype.min = function () {
    return Math.min.apply(null, this);
};

function parseDate(str) {
    var mdy = str.split('-')
    return new Date(mdy[0], mdy[1] - 1, mdy[2]);
}

function daydiff(first, second) {
    return Math.floor((second - first) / (1000 * 60 * 60 * 24))
}

function median(values) {
    
    values.sort(function (a, b) {
        return a - b;
    });

    var half = Math.floor(values.length / 2);

    if (values.length % 2) return values[half];
    else return (values[half - 1] + values[half]) / 2.0;
}

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

// Callback that creates and populates a data table,
// instantiates the pie chart, passes in the data and
// draws it.
function drawChart(result, counter) {
        var data = new google.visualization.DataTable();

        var splitResult;
        var splitDate;
        var x;
        var columnIndex = 2;


        // Declare columns
        data.addColumn('date', 'Date');
        data.addColumn('number', selectedParameter + ' (' + result.data[0].unit + ')');

        if (pValue <= .05 && result.data.length > 1) {
            data.addColumn('number', 'Trend');
            columnIndex = columnIndex + 1;
        }


        for (var i = 0; i < result.data.length; i++) {
            //splitResult = checkedResults[i].value.split(" ");
            splitDate = result.data[i].date.split("-");

            //x = daydiff(parseDate(result.data[0].date), parseDate(result.data[i].date));
            x = daydiff(parseDate(result.data[i].date), parseDate(result.data[0].date));
           
            if (pValue <= .05 && result.data.length > 1) {
                var slopeVal = (senSlope * (x) + senB);
                //slopeVal = slopeVal * -1;
                data.addRow([new Date(splitDate[0], splitDate[1] - 1, splitDate[2]), result.data[i].value, slopeVal]);
            }
            else {
                data.addRow([new Date(splitDate[0], splitDate[1] - 1, splitDate[2]), result.data[i].value]);
            }

        }

        if ($.isNumeric($("#lowThreshChartsInput").val())) {
            data.addColumn('number', 'Lower Threshold');
            data.setCell(0, columnIndex, $("#lowThreshChartsInput").val());
            data.setCell(result.data.length - 1, columnIndex, $("#lowThreshChartsInput").val());
            columnIndex = columnIndex + 1;
        }

        if ($.isNumeric($("#upperThreshChartsInput").val())) {
            data.addColumn('number', 'Upper Threshold');
            data.setCell(0, columnIndex, $("#upperThreshChartsInput").val());
            data.setCell(result.data.length - 1, columnIndex, $("#upperThreshChartsInput").val());
        }

        var options = {
            // chartArea: {'width': '67%', 'height': '60%'},
            title: result.location,
            hAxis: { title: 'Date (M/Y)', format: 'M/yy' },
            vAxis: { title: selectedParameter + ' (' + result.data[0].unit + ')' },
            legend: { textStyle: { fontSize: 10 } },
            interpolateNulls: true,
            chartArea: { width: "60%", height: "70%" },
            series: { 0: { lineWidth: 0, pointSize: 5 }, 1: { lineWidth: 1, pointSize: 0 }, 2: { lineWidth: 1, pointSize: 0 }, 3: { lineWidth: 1, pointSize: 0 } },
            height: 400,
            width: 850

        };

        $("#trendCharts").append('Location: <b>' + result.location + '</b><br>');

        //    var tempLi = "<li data-target='#myCarousel' data-slide-to=" + counter + " class='active'></li>"
        //    $("#carouselol").append(tempLi);

        //    var tempDiv = "<div class='item' style='height:inherit'><div class='container'><div class='carousel-caption'><div id='carouselCharts" + result.location + "'></div></div></div></div>"
        //    $("#carouselInner").append(tempDiv);

        $("#trendCharts").append('<div id="trendCharts' + result.location + '"></div>');

        var chart = new google.visualization.LineChart(document.getElementById('trendCharts' + result.location));
        chart.draw(data, options);

        //    var chart = new google.visualization.LineChart(document.getElementById('carouselCharts' + result.location));
        //    chart.draw(data, options);
        //    $(window).resize(function () {
        //        chart.draw(data, options);
        //    });

        if (result.data.length < 5) {
            $("#trendCharts").append('Cannot do trend analysis on 4 or less values.<br>');
        }else if (pValue <= .05 && result.data.length > 1) {
            //$("#trendCharts").append('The Mann-Kendall test for trend has a p-value of ' + pValue.toFixed(4) + ' and is significant at the 0.05 level.  The Theil-Sen estimate of slope is ' + senSlope.toFixed(4) + ' and the intercept is ' + senB.toFixed(4) + '.<br>');
            $("#trendCharts").append('The Mann-Kendall test for trend is significant at the 0.05 level.  The Theil-Sen estimate of slope is ' + senSlope.toFixed(4) + ' and the intercept is ' + senB.toFixed(4) + '.<br>');
        }
        //else if (result.data.length == 1) {
        //    $("#trendCharts").append('There is only one data point.  Need at least two for trend calculations.<br>');
        //}
        else {
            //$("#trendCharts").append('The Mann-Kendall test for trend has a p-value of ' + pValue.toFixed(4) + ' and is not significant at the 0.05 level.<br>');
            $("#trendCharts").append('The Mann-Kendall test for trend is not significant at the 0.05 level.<br>');
        }
    
    //$(".pvalue").html(pValue.toFixed(4));
    //$(".slope").html(senSlope.toFixed(4));
    //$(".intercept").html(senB.toFixed(4));
}

function clearAllCharts()
{

    // clear trend charts
    document.getElementById("trendCharts").innerHTML = "";
    
//    var createCarousel = "<div id='myCarousel' class='carousel slide' style='height:500px' data-ride='carousel'>"
//                        + "<ol id='carouselol' class='carousel-indicators'>"
//                        + "<li id='carouselPlaceholderLi' data-target='#myCarousel' data-slide-to='0' class='active'></li>"
//                       + "</ol>"
//                        + "<div id='carouselInner' class='carousel-inner' style='height:inherit'>"
//                        + "<div id='carouselPlaceholderDiv' class='item active' style='height:inherit; '>"
//                        + "<div class='container'>"
//                        + "<div class='carousel-caption'>"
//                        + "<h1>END</h1>"
//                        + "<p></p>"
//                        + "<p></p>"
//                        + "</div>"
//                        + "</div>"
//                        + "</div>"
//                        + "</div>"
//                        + "<a class='left carousel-control' href='#myCarousel' role='button' data-slide='prev'><span class='glyphicon glyphicon-chevron-left'></span></a>"
//                        + "<a class='right carousel-control' href='#myCarousel' role='button' data-slide='next'><span class='glyphicon glyphicon-chevron-right'></span></a>"
//                        + "</div>";
//    document.getElementById("carouselDiv").innerHTML = createCarousel;

    // clear box whisker charts
    //var svg = d3.select("#boxWhiskerPlot").selectAll("svg").remove();
    
    //document.getElementById("analyzeBoxXAxis").innerHTML = "";

  //  $(".searchQueryDisplay").innerHTML = "";

}

// chart all of the site data on one graph
function makeMasterChart() {
    var data = new google.visualization.DataTable();

    var splitResult;
    var splitDate;
    var rowCount = 0;

    // Declare columns
    data.addColumn('date', 'Date');
    
    
    for(var i=0; i<checkedResults.length; i++)
    {
        data.addColumn('number', checkedResults[i].location);

        for(var j=0; j<checkedResults[i].data.length; j++)
        {
            splitDate = checkedResults[i].data[j].date.split("-");

            data.addRow();
            data.setCell(rowCount, 0, new Date(splitDate[0], splitDate[1] - 1, splitDate[2]));
            data.setCell(rowCount, i + 1, checkedResults[i].data[j].value);
            rowCount = rowCount + 1;
        }
    }



    var options = {
        // chartArea: {'width': '67%', 'height': '60%'},
        title: "Site Data",
        hAxis: { title: 'Date (M/Y)', format: 'M/yy' },
        vAxis: { title: 'Measured Value' },
        chartArea: { width: "60%", height: "70%" },
        legend: { textStyle: { fontSize: 10 } },
        lineWidth: 0, 
        pointSize: 5,
        height: 400,
        width: 850

    };

    var chart = new google.visualization.LineChart(document.getElementById('trendChartsMaster'));
    chart.draw(data, options);

}

function clearAllCharts() {

    // clear trend charts
    document.getElementById("trendCharts").innerHTML = "";

    // clear box whisker charts
    //var svg = d3.select("#boxWhiskerPlot").selectAll("svg").remove();

    //document.getElementById("analyzeBoxXAxis").innerHTML = "";

    //  $(".searchQueryDisplay").innerHTML = "";

}

