<%@ Page Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="SearchAnalyze.aspx.cs" Inherits="OpenEnvironment.App_Pages.Secure.SearchAnalyze" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
  
      
   <%-- <link href="../../css/SearchAnalyze.css" rel="stylesheet" />--%>
  
    
    <style>
        <!--Style for Box Charts-->
        .box {
          font: 10px sans-serif;
        }

        .box line,
        .box rect,
        .box circle {
          fill: steelblue;
          stroke: #000;
          stroke-width: 1px;
        }



        .box .outlier {
          fill: none;
          stroke: #000;
        }

        .axis {
          font: 12px sans-serif;
        }
 
        .axis path,
        .axis line {
          fill: none;
          stroke: #000;
          shape-rendering: crispEdges;
        }
 
        .x.axis path { 
          fill: none;
          stroke: #000;
          shape-rendering: crispEdges;
        }

        #trendCharts
        {
            font-size: 16px;
        }

        
        .inlinelinks  {

        display: inline;
        list-style-type: none;
        margin-right: 34px;

        } 

        </style>





        <!--[if lt IE 10]><link rel="stylesheet" type="text/css" href="css/ie.css"/><![endif]-->
        
       <%-- <script type="text/javascript" src="../../js/plugins/jquery/jquery.min.js"></script>
        <script type="text/javascript" src="../../js/plugins/jquery/jquery-ui.min.js"></script>
        <script type="text/javascript" src="../../js/plugins/bootstrap/bootstrap.min.js"></script>
        <script type="text/javascript" src="../../js/plugins/mcustomscrollbar/jquery.mCustomScrollbar.min.js"></script>  --%>              
        
        <script type="text/javascript" src="../../js/plugins/bootstra-wizard/jquery.bootstrap.wizard.min.js"></script>
        
       <%-- <script type="text/javascript" src="../../js/plugins/jquery-validation/jquery.validate.min.js"></script>
        <script type="text/javascript" src="../../js/plugins/jquery-validation/additional-methods.min.js"></script>--%>
        
      <%--  <script type="text/javascript" src="../../js/plugins.js"></script>
        <script type="text/javascript" src="../../js/demo.js"></script>
        <script type="text/javascript" src="../../js/actions.js"></script>     --%>

    
   <%-- <script src="../../Scripts/jQueryAssets/jquery-1.8.3.min.js" type="text/javascript"></script>
	<script src="../../Scripts/jQueryAssets/-1.9.2.tabs.custom.min.js" type="text/javascript"></script>
	<script src="../../Scripts/jQueryAssets/jquery-ui-1.9.2.button.custom.min.js" type="text/javascript"></script>
	<script src="../../Scripts/jQueryAssets/jquery-ui-1.9.2.dialog.custom.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jQueryAssets/jquery-ui-1.9.2.datepicker.custom.min.js" type="text/javascript"></script>--%>
    <!--<link href="../../css/bootstrapmap.css" rel="stylesheet" />
    <script src="../../js/bootstrapmap.js"></script>-->
    <script src="http://code.highcharts.com/highcharts.js"></script>
    <script src="http://code.highcharts.com/highcharts-more.js"></script>
    <script src="http://code.highcharts.com/modules/exporting.js"></script>

    <!--<script src="http://d3js.org/d3.v3.min.js" type="text/javascript"></script>
    <script src="../../Scripts/box.js" type="text/javascript"></script>-->
    
    <script src="../../Scripts/jQueryAssets/FipsCountyCodes.js" type="text/javascript"></script>

    <script src="../../Scripts/SearchAnalyze.js" type="text/javascript"></script>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        var package_path = window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/'));
        var dojoConfig = {
            //The location.pathname.replace() logic below may look confusing but all its doing is
            // enabling us to load the api from a CDN and load local modules from the correct location.
            packages: [{
                name: "application",
                location: package_path + '../../../js'
            }, {
                name: "bootstrap",
                location: "//rawgit.com/xsokev/Dojo-Bootstrap/master"
            }]
        };
    </script>
    <script src="http://js.arcgis.com/3.10/"></script>
		<script type="text/javascript">
		    // Load the Visualization API and the piechart package.
		    google.load('visualization', '1.0', { 'packages': ['corechart'] });

		    // Set a callback to run when the Google Visualization API is loaded.
		    // google.setOnLoadCallback(drawChart);


		    var map;
		    var legend;
		    var localOrganizationSymbol, webOrganizationSymbol;
		    var symbolShapes;
		    var symbolColors = [[255, 0, 0], [102, 51, 0], [0, 153, 0], [255, 255, 0], [102, 0, 51], [255, 128, 0]];
		    var hexColors = ["FF0000", "663300", "009900", "FFFF00", "660033", "FF8000"];

		    require([
              "esri/map", "esri/dijit/BasemapGallery", "esri/arcgis/utils",
              "dojo/parser", "esri/layers/GraphicsLayer", "esri/graphic", "esri/geometry/Point", "esri/symbols/SimpleMarkerSymbol",
              "esri/Color", "esri/InfoTemplate", "dojo/_base/array", "esri/geometry/Multipoint", "esri/SpatialReference",
              "esri/geometry/webMercatorUtils", "dojo/query", "dojo/touch",
              "application/bootstrapmap", "esri/dijit/Scalebar", "esri/dijit/Legend",
              "dijit/layout/BorderContainer", "dijit/layout/ContentPane", "dijit/TitlePane", "dojo/on",
              "dojo/domReady!"
		    ], function (
              Map, BasemapGallery, arcgisUtils,
              parser,
              GraphicsLayer, Graphic, Point, SimpleMarkerSymbol,
              Color, InfoTemplate, arrayUtils, MultiPoint, SpatialReference,
              webMercatorUtils, query, touch, BootstrapMap, Scalebar, Legend
            ) {
		        parser.parse();
		        symbolShapes = [SimpleMarkerSymbol.STYLE_CIRCLE, SimpleMarkerSymbol.STYLE_DIAMOND, SimpleMarkerSymbol.STYLE_SQUARE, SimpleMarkerSymbol.STYLE_CROSS, SimpleMarkerSymbol.STYLE_X];
		        map = BootstrapMap.create("map", {
		            basemap: "national-geographic",
		            center: [-83.82678, 35.46913],
		            zoom: 10
		        });

		        var today = new Date();
		        var dd = today.getDate();
		        var mm = today.getMonth() + 1; //January is 0!
		        var yyyy = today.getFullYear();

		        if (dd < 10) {
		            dd = '0' + dd
		        }

		        if (mm < 10) {
		            mm = '0' + mm
		        }

		        today = mm + '/' + dd + '/' + yyyy;
		        initial = mm + '/' + dd + '/' + (yyyy - 3);
		        $("#beginDateInput").val(initial);
		        $("#endDateInput").val(today);

		        var scalebar = new Scalebar({
		            map: map,
		            scalebarUnit: "dual"
		        });

		        map.on("extent-change", extentHandler);
		        //legend = new Legend({
		        //    map: map
		        //}, "legendDiv");
		        //legend.startup();

		        PageMethods.GetSites(OnGetSitesComplete);

		        localOrganizationSymbol = new SimpleMarkerSymbol().setColor(new Color([0, 0, 255]));
		        webOrganizationSymbol = new SimpleMarkerSymbol().setColor(new Color([0, 255, 255]));
		        highlightSymbol = new SimpleMarkerSymbol().setColor(new Color([255, 0, 0]));

		    });

		    var localLocs;
		    function OnGetSitesComplete(result, userContext, methodName) {
		        var locs = [];
		        for (var i = 0; i < result.length; i++) {
		            splits = result[i].split("|");
		            var loc = { xloc: splits[1], yloc: splits[0], name: splits[2].split("-")[0], type: splits[2].split("-")[1] };
		            locs.push(loc);
		        }
		        //console.log(locs);
		        localLocs = locs;

		        loadLocalSites();
		    }

		    function loadLocalSites() {
		        map.graphics.clear();
		        $('#allOrganizationShown').val('');
		        if (localLocs != null) {
		            placeGraphics(localLocs, true, 'local');
		        }
		    }

		    //testGraphics();
		    var gl, gw;

		    function mouseOverGraphic(evt) {
		        alert("here");
		    }
		    function graphicClicked(evt) {
		        mouseOutEvent.pause();
		        setTimeout(function () { mouseOutEvent.resume(); }, 3000);
		        var long = evt.graphic.geometry.x;
		        var lat = evt.graphic.geometry.y;
		        $("#latInput").val(lat);
		        $("#longInput").val(long);
		    }
		    var mouseOverEvent, mouseOutEvent;
		    function placeGraphics(locs, setExtent, source) {
		        require(["esri/geometry/Multipoint", "esri/SpatialReference", "esri/layers/GraphicsLayer", "dojo/_base/array",
                        "esri/geometry/Point", "esri/symbols/SimpleMarkerSymbol", "esri/Color", "esri/InfoTemplate", "esri/graphic",
                         "dojo/on", "esri/layers/FeatureLayer", ],
                function (Multipoint, SpatialReference, GraphicsLayer, arrayUtils,
                        Point, SimpleMarkerSymbol, Color, InfoTemplate, Graphic, on) {

                    //if(source == 'local'){
                    //    if(gl){
                    //        map.removeLayer(gl);
                    //    }
                    //    gl = new GraphicsLayer();
                    //    gl.on('click', graphicClicked);
                    //}else{
                    //    if(gw){
                    //        map.removeLayer(gw);
                    //    }
                    //    gw = new GraphicsLayer();
                    //    gw.on('click', graphicClicked);
                    //}
                    if (gl) {
                        map.removeLayer(gl);
                    }
                    if (gw) {
                        map.removeLayer(gw);
                    }
                    gl = new GraphicsLayer();
                    gl.on('click', graphicClicked);
                    //gl.on(mouse.enter, mouseOverGraphic);
                    gw = new GraphicsLayer();
                    gw.on('click', graphicClicked);
                    //gw.on(mouse.enter, mouseOverGraphic)
                    mouseOverEvent = on.pausable(gw, "MouseOver", function (evt) {
                        var g = evt.graphic;
                        map.infoWindow.setContent(g.attributes.orgFullName);
                        map.infoWindow.setTitle("Organization");
                        map.infoWindow.show(evt.screenPoint, map.getInfoWindowAnchor(evt.screenPoint));
                        mouseOverEvent.pause();
                        setTimeout(function () { mouseOverEvent.resume(); }, 100);
                    });
                    mouseOutEvent = on.pausable(gw, "MouseOut", function () { map.infoWindow.hide(); });


                    var multiPoint = new Multipoint(new SpatialReference(4326));

                    //                var locs = [{ xloc: -84.7300, yloc: 38.9700, county: 'boone' },
                    //            { xloc: -84.5400, yloc: 38.9300, county: 'kenton' },
                    //            { xloc: -84.3800, yloc: 38.9500, county: 'campbell' }
                    //                ];

                    arrayUtils.forEach(locs, function (entry) {
                        var xloc = entry.xloc;
                        var yloc = entry.yloc;
                        xloc = xloc.replace("(", "");
                        xloc = xloc.replace(")", "");

                        //console.log(xloc + " : " + yloc);

                        //var pt = new Point(xloc, yloc, new SpatialReference(4326));
                        var pt = new Point(xloc, yloc, new SpatialReference(4326));
                        multiPoint.addPoint(pt);

                        var setSymbol;
                        if (source == 'local') {
                            setSymbol = localOrganizationSymbol;
                        } else {
                            setSymbol = entry.symbol;

                        }

                        var attr = { "Xcoord": xloc, "Ycoord": yloc, "Name": entry.name, "Type": entry.type, "locID": entry.locID, "defaultSymbol": setSymbol, "orgID": entry.orgID, "orgFullName": entry.orgFullName };

                        var infoTemplate = new InfoTemplate("Water Monitoring Station", "Name:${Name} <br/>Type:${Type}");

                        var graphic = new Graphic(pt, setSymbol, attr, infoTemplate);
                        require(["dojo/on"], function (on) {
                            //on(graphic, "mouseover", function () { alert("HERE"); });
                            //graphic.on("mouseover", function () { alert("HERE"); });
                        })
                        if (source == 'local') {
                            gl.add(graphic);
                        } else {
                            gw.add(graphic);
                        }

                    });
                    if (source == 'local') {
                        map.addLayer(gl);
                        // legend.refresh([{ layer: gl }]);
                    } else {
                        map.addLayer(gw);
                        //legend.refresh([{ layer: gw }]);
                    }

                    if (setExtent) {
                        map.setExtent(multiPoint.getExtent().expand(1.5));
                    }
                });
		    }

		    function extentHandler(evt) {
		        require(["esri/geometry/webMercatorUtils"], function (webMercatorUtils) {
		            var extent = evt.extent.expand(2);
		            var xmax = extent.xmax;
		            var xmin = extent.xmin;
		            var ymax = extent.ymax;
		            var ymin = extent.ymin;
		            var northWest = webMercatorUtils.xyToLngLat(xmax, ymax);
		            var southEast = webMercatorUtils.xyToLngLat(xmin, ymin);
		            $("#extentBBox").val(southEast[0] + "%2C" + southEast[1] + "%2C" + northWest[0] + "%2C" + northWest[1]);
		        });

		        //console.log(xmax + " | " + xmin + " | " + ymax + " | " + ymin);
		    }
		    function plotPoints(forOrganization) {
                map.graphics.clear();
		        $('#allOrganizationShown').val('true');
		        //var queryURL = 'http://www.waterqualitydata.us/Station/search?bBox=' + $("#extentBBox").val() + '&characteristicName=' + $("#parameterSelect").val() + '&sampleMedia=Water&mimeType=xml';
		        var queryURL = 'http://www.waterqualitydata.us/Station/search?bBox=' + $("#extentBBox").val() + '&mimeType=xml&sampleMedia=Water&startDateLo=' + $("#beginDateInput").val().replace("/", "-").replace("/", "-") + '&startDateHi=' + $("#endDateInput").val().replace("/", "-").replace("/", "-");
		        if (forOrganization) {
		            queryURL += '&organization=' + $("#parameterOrganization").val();
		            $('#allOrganizationShown').val('false');
		        }
		        //console.log(queryURL);
		        $.ajax({
		            type: 'GET',
		            dataType: 'xml',
		            timeout: 280000,
		            url: queryURL,

		            success: function (data) {
		                // document.getElementById("xmlQuery").innerHTML = "Query: " + queryURL;
		                // $("#xmlOutput").val(new XMLSerializer().serializeToString(data));
		                if (data) {
		                    var xmlDoc;
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
		                    var locs = [];
		                    require(["dojo/_base/array", "esri/symbols/SimpleMarkerSymbol", "esri/Color"], function (arrayUtils, SimpleMarkerSymbol, Color) {
		                        var symbolCounter = 0;
		                        var colorCounter = 0;
		                        arrayUtils.forEach(xmlDoc.getElementsByTagName("Organization"), function (entry) {
		                            var orgSymbol;

		                            var organization = entry.getElementsByTagName("OrganizationDescription")[0].getElementsByTagName("OrganizationIdentifier")[0].childNodes[0].nodeValue;
		                            var organizationFormalName = entry.getElementsByTagName("OrganizationDescription")[0].getElementsByTagName("OrganizationFormalName")[0].childNodes[0].nodeValue;

		                            if (organization == $("#parameterOrganization").val()) {
		                                orgSymbol = webOrganizationSymbol;
		                            } else {
		                                if (colorCounter++ > 5) {
		                                    colorCounter = 0;
		                                    symbolCounter++;
		                                }
		                                orgSymbol = new SimpleMarkerSymbol().setColor(new Color(symbolColors[colorCounter])).setStyle(symbolShapes[symbolCounter]);
		                            }
		                            arrayUtils.forEach(entry.getElementsByTagName("MonitoringLocation"), function (monitoringEntry) {
		                                var monitoringLoc = monitoringEntry.getElementsByTagName("MonitoringLocationGeospatial")[0];
		                                var long = monitoringLoc.getElementsByTagName("LongitudeMeasure")[0].childNodes[0].nodeValue;
		                                var lat = monitoringLoc.getElementsByTagName("LatitudeMeasure")[0].childNodes[0].nodeValue;
		                                var site = monitoringEntry.getElementsByTagName("MonitoringLocationIdentity")[0];

		                                var locName = site.getElementsByTagName("MonitoringLocationName")[0].childNodes[0].nodeValue;
		                                var locType = site.getElementsByTagName("MonitoringLocationTypeName")[0].childNodes[0].nodeValue;
		                                var locId = site.getElementsByTagName("MonitoringLocationIdentifier")[0].childNodes[0].nodeValue;

		                                var loc = { xloc: long, yloc: lat, name: locName, type: locType, locID: locId, orgID: organization, orgFullName: organizationFormalName, symbol: orgSymbol };
		                                locs.push(loc);
		                            });




		                        });
		                    });

		                    placeGraphics(locs, false, 'web');
		                }



		                //loadResultsTable();
		            },
		            beforeSend: function () {
		                // show gif here, eg:

		                // clear results table
		                //while (document.getElementById("resultsTable").rows.length > 1) {
		                //    document.getElementById("resultsTable").deleteRow(1);
		                //}

		                $("#loading").show();
		                $("#progressImg").show();
		                document.body.style.cursor = "progress";

		            },
		            complete: function () {
		                // hide gif here, eg:
		                $("#loading").hide();
		                $("#progressImg").hide();
		                document.body.style.cursor = "default";
		            },
		            error: function (t) {
		                // show gif here, eg:
		                //$("#loading").hide();
		                //document.body.style.cursor = "default";
		                alert("Unable to connect to water quality data.\nQuery: " + queryURL);
		                $("#progressImg").hide();
		                //document.getElementById("xmlQuery").innerHTML = "Query Attempt: " + queryURL;
		            }
		        });
		    }
		    var tb, tbEvent;
		    function enableDraw(type) {
		        require(["esri/toolbars/draw"], function (Draw) {
		            map.infoWindow.hide();
		            if (!tb) {
		                tb = new Draw(map);
		            }

		            if (!tbEvent) {
		                tbEvent = tb.on("draw-complete", addGraphic);
		            }
		            map.graphics.clear();
		            map.disableMapNavigation();
		            if (type == 'EXTENT') {
		                tb.activate(Draw.EXTENT);
		            } else {
		                tb.activate(Draw.POLYGON);
		            }
		        });
		    }

		    function clearUserSelection() {
		        document.getElementById("accordion").innerHTML = "";

		        //This is commented because the grid has changed.  Will need to clear the grid once that is re-implemented
		        //while (document.getElementById("resultsTable").rows.length > 1) {
		        //    document.getElementById("resultsTable").deleteRow(1);
		        //}
		        if (tb) {
		            tb.deactivate();
		        }

		        map.infoWindow.hide();
		        map.graphics.clear();
		        $('#parameterSiteIDs').val('');
		        $("#parameterBBox").val('');
		        $("#latInput").val('');
		        $("#longInput").val('');

		        require(["dojo/_base/array"], function (arrayUtils) {
		            if (gl) {
		                arrayUtils.forEach(gl.graphics, function (graphic) {
		                    var resetSymbol = graphic.attributes.defaultSymbol;
		                    graphic.setSymbol(resetSymbol);
		                });
		            }
		            if (gw) {
		                arrayUtils.forEach(gw.graphics, function (graphic) {
		                    var resetSymbol = graphic.attributes.defaultSymbol;
		                    graphic.setSymbol(resetSymbol);
		                });
		            }
		        });

		    }

		    function addGraphic(evt) {
		        require(["esri/geometry/webMercatorUtils", "esri/geometry/Polygon", "dojo/_base/array"],
                function (webMercatorUtils, Polygon, arrayUtils) {
                    var userGeometry = evt.geometry;

                    if (evt.geometry.type == 'extent') {
                        var xmax = userGeometry.xmax;
                        var xmin = userGeometry.xmin;
                        var ymax = userGeometry.ymax;
                        var ymin = userGeometry.ymin;
                        var northWest = webMercatorUtils.xyToLngLat(xmax, ymax);
                        var southEast = webMercatorUtils.xyToLngLat(xmin, ymin);

                        $("#parameterBBox").val(southEast[0] + "%2C" + southEast[1] + "%2C" + northWest[0] + "%2C" + northWest[1]);

                        var polygonJson = {
                            "rings": [[[xmax, ymax], [xmax, ymin], [xmin, ymin], [xmin, ymax],
                                [xmax, ymax]]], "spatialReference": { "wkid": userGeometry.spatialReference.wkid }
                        };
                        var polygon = new Polygon(polygonJson);
                        userGeometry = polygon;
                        drawGraphicOnScreen(userGeometry, true);
                    } else {
                        drawGraphicOnScreen(userGeometry, true);
                    }
                    $('#parameterSiteIDs').val('');
                    if (gl) {
                        arrayUtils.forEach(gl.graphics, function (graphic) {
                            if (userGeometry.contains(graphic.geometry)) {
                                //The parameterSiteIDs is only applicable for WEB.  Local data will need a unique query
                                //var sites = $('#parameterSiteIDs').val();
                                //if (sites != '') {
                                //    sites += ";"
                                //}

                                //sites += graphic.attributes.locID;
                                //$('#parameterSiteIDs').val(sites);
                                graphic.setSymbol(highlightSymbol);
                            }
                                //else if point was previously highlighted, reset its symbology
                            else {
                                var resetSymbol = graphic.attributes.defaultSymbol;
                                graphic.setSymbol(resetSymbol);
                            }
                        });
                    }
                    if (gw) {
                        arrayUtils.forEach(gw.graphics, function (graphic) {
                            if (userGeometry.contains(graphic.geometry)) {
                                var sites = $('#parameterSiteIDs').val();
                                if (sites != '') {
                                    sites += ";"
                                }

                                sites += graphic.attributes.locID;
                                $('#parameterSiteIDs').val(sites);
                                graphic.setSymbol(highlightSymbol);
                                //results.push(graphic.getContent());
                            }
                                //else if point was previously highlighted, reset its symbology
                            else {
                                var resetSymbol = graphic.attributes.defaultSymbol;
                                graphic.setSymbol(resetSymbol);
                            }
                        });
                    }

                });

		    }
		    function drawGraphicOnScreen(userGeometry) {
		        require(["esri/symbols/SimpleFillSymbol", "esri/symbols/SimpleLineSymbol", "dojo/_base/Color", "esri/graphic"],
                    function (SimpleFillSymbol, SimpleLineSymbol, Color, Graphic) {
                        map.graphics.clear();

                        var fillSymbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID,
                              new SimpleLineSymbol(SimpleLineSymbol.STYLE_DASHDOT,
                              new Color([255, 0, 0]), 2), new Color([255, 255, 0, 0.25]))

                        var graphic = new Graphic(userGeometry, fillSymbol);

                        map.graphics.add(graphic);
                        tb.deactivate()
                        map.enableMapNavigation();

                    });
		    }

		    //add the basemap gallery, in this case we'll display maps from ArcGIS.com including bing maps
		    function switchBasemap(e) {
		        switch (e) {
		            case "Streets":
		                map.setBasemap("streets");
		                break;
		            case "Imagery":
		                map.setBasemap("hybrid");
		                break;
		            case "National Geographic":
		                map.setBasemap("national-geographic");
		                break;
		            case "Topographic":
		                map.setBasemap("topo");
		                break;
		            case "Gray":
		                map.setBasemap("gray");
		                break;
		            case "Open Street Map":
		                map.setBasemap("osm");
		                break;
		        }
		    }
    </script>
     <script>

         var boolBC = true;



         function AddData() {
             // $("#hdnPK").val("-1");
             //$("#lblTitle").text("Add New Product");
             //$("#txtProductName").val("");
             //$("#txtIntroductionDate").val(new Date().toLocaleDateString());
             //$("#txtCost").val("0");
             //$("#txtPrice").val("0");
             //$("#btnSave").val("Create Product");
             // $("#hdnAddMode").val("true");
             $('#datUploadResults').show();
             //$('#btnAdd').addClass("hidden");
             //$('#gridArea').hide();
         }

         function RemoveData() {
             // $("#hdnPK").val("-1");
             //$("#lblTitle").text("Add New Product");
             //$("#txtProductName").val("");
             //$("#txtIntroductionDate").val(new Date().toLocaleDateString());
             //$("#txtCost").val("0");
             //$("#txtPrice").val("0");
             //$("#btnSave").val("Create Product");
             // $("#hdnAddMode").val("true");
             $('#datUploadResults').hide();
             boolBC = false;
             //$('#btnAdd').addClass("hidden");
             //$('#gridArea').hide();

         }

         function block_toggle() {

             if (boolBC == false) {

                 $('#closeBlkCnt').hide();

                 boolBC = true;

             }
             else {
                 $('#closeBlkCnt').show();

                 boolBC = false;

             }
         }





  </script>
     <style type="text/css"> 
        /*#over_map { position: absolute; background-color: #666666; padding:5px; top: 130px; left: 280px; font-weight:bold; color:White; z-index: 99; border-color:#333333; border-width:1px; border-style:solid; border-radius: 5px 5px / 5px 5px; font-size: 11pt; box-shadow: 3px 3px 3px #888888;  opacity: 0.6; filter: alpha(opacity=60); }
        #over_map_right { position: absolute; background-color: transparent; top: 130px; right: 120px; z-index: 99; }*/
        /*.row {

            margin-left: 40px;
        }*/
      #map {
        height:500px;
        max-height: 500px; 
        width: 100%;

      }
      #btnSearchAnal {margin-bottom: 4px; }
      
      @media (max-width:992px){
        .navbar-header {
            float: none;
        }
        .navbar-left,.navbar-right {
            float: none !important;
        }
        .navbar-toggle {
            display: block;
        }
        .navbar-collapse {
            border-top: 1px solid transparent;
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.1);
        }
        .navbar-fixed-top {
              top: 0;
              border-width: 0 0 1px;
         }
        .navbar-collapse.collapse {
            display: none!important;
        }
        .navbar-nav {
            float: none!important;
              margin-top: 7.5px;
         }
         .navbar-nav>li {
            float: none;
        }
        .navbar-nav>li>a {
            padding-top: 10px;
            padding-bottom: 10px;
        }
        .collapse.in{
              display:block !important;
         } 
    }
    
    </style>

    <ajaxToolkit:ToolkitScriptManager ID="scriptManager" runat="server" AsyncPostBackTimeout="99999999" EnablePageMethods="true" />      
    

    <div class="contentArea" >
        <div class="row">
            <div class="col-md-12">
                <div class="block form-wizard" id="form-wizard">
                    <ul>
                        <li><a href="#pane1" data-toggle="tab"><span>1</span> Search Map</a></li>
                        <li><a href="#pane2" data-toggle="tab"><span>2</span> Select Data</a></li>
                        <li><a href="#pane3" data-toggle="tab"><span>3</span> View Charts</a></li>
                       
                        <%--
                        <li><a href="#pane4" data-toggle="tab"><span>4</span> View Report</a></li>
                        <li><a href="#pane5" data-toggle="tab"><span>5</span> Save Search</a></li>
                        --%>
                        
                         </ul>
                <div class="block-content">
                    <div class="row">
                        <div class="col-sm-6">
                            <h2><strong>WQX Search & Analyze</strong> Wizard</h2>
                        </div>
                    <%--<p>Follow the steps above to complete the Search and Analyze process.</p>--%>
                        <div class="col-sm-6">
                            <div id="loading" style="display: none;">
                            <h2>Loading... </h2>
                        </div>
                    </div>
                </div>

                    <div class="tab-content">
                        <div id="pane1" class="tab-pane active">
                            <div class="row">
                                <div class="col-xs-12">
                                    <div  class="block">  
                                        <div class="row" >           
                                            <div class="col-sm-2" >             
                                                <ul>
                                                    <li >
                                                        <a href="#" id="lnkMaint" class="dropdown-toggle" data-toggle="dropdown" >Base Layer<b class="caret"></b></a>
                                                        <ul id="ulMaint" class="dropdown-menu" >
                                                            <li ><a style="cursor:pointer" onclick="switchBasemap('Streets');">Streets</a></li>
                                                            <li><a style="cursor:pointer" onclick="switchBasemap('Imagery');">Imagery</a></li>
                                                            <li><a style="cursor:pointer" onclick="switchBasemap('National Geographic');">National Geographic</a></li>
                                                            <li><a style="cursor:pointer" onclick="switchBasemap('Topographic');">Topographic</a></li>
                                                            <li><a style="cursor:pointer" onclick="switchBasemap('Gray');">Gray</a></li>
                                                            <li><a style="cursor:pointer" onclick="switchBasemap('Open Street Map');">Open Street Map</a></li>
                                                        </ul>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="col-sm-2" >   
                                                <ul>
                                                    <li  id="siteList">
                                                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Show Sites <b class="caret"></b></a>
                                                        <ul class="dropdown-menu" id="siteDropdown">
                                                            <li>
                                                                <a style="cursor:pointer" onclick="loadLocalSites();">Local</a>
                                                            </li>
                                                            <li>
                                                                <a style="cursor:pointer" onclick="plotPoints(true);">Water Quality Portal</a>
                                                            </li>
                                                            <li>
                                                                <a style="cursor:pointer" onclick="plotPoints(false);">Water Quality Portal - All</a>
                                                            </li>
                                                        </ul>
                                                    </li>
                                                </ul> 
                                            </div> 
                                            <div class="col-sm-2" >   
                                                <ul>
                                                    <li class="inlinelinks">
                                                        <a href="#"  class="dropdown-toggle" data-toggle="dropdown">Select Region<b class="caret"></b></a>
                                                        <ul id="ul3Maint"  class="dropdown-menu">
                                                            <li>
                                                                <a style="cursor:pointer" onclick="enableDraw('EXTENT');">Rectangle</a>
                                                            </li>
                                                            <li>
                                                                <a style="cursor:pointer" onclick="enableDraw('POLYGON');">Polygon</a>
                                                            </li>
                                                        </ul>
                                                    </li>
                                               </ul>
                                            </div>
                                            <div class="col-sm-2" >   
                                                <ul>
                                                    <li class="inlinelinks">
                                                        <a style="cursor:pointer" onclick="clearUserSelection();" class="dropdown-toggle" data-toggle="dropdown">Clear Selection</a>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="col-sm-2" >   
                                                <ul>
                                                    <li class="inlinelinks">
                                                        <a style="cursor:pointer" id="submitUsetTaskBtn" onclick="submitUsetData();" class="dropdown-toggle" data-toggle="dropdown">Submit</a>
                                                    </li>                 
                                                </ul> 
                                            </div> 
                                        </div>
                                        <div id="closeBlkCnt" class="block-content">
                                            <div hidden="hidden">
                                                <asp:DropDownList ID="parameterOrganization" ClientIDMode="Static" runat="server"></asp:DropDownList>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-4">
                                                <%-- Characteristic <span style="color:red">*</span> --%>
                                                    <select id="parameterSelect" class="form-control">
                                                        <!--<option value="Dissolved+oxygen+(DO)" selected="selected">Dissolved Oxygen (DO)</option>
                                                        <option value="Temperature%2C+water">Temperature, water</option>
                                                        <option value="pH">pH</option>
                                                        <option value="Turbidity">Turbidity</option>
                                                        <option value="Escherichia+coli">E-coli</option>  
                                                        <option value="Nitrogen%2C+mixed+forms+(NH3)%2C+(NH4)%2C+organic%2C+(NO2)+and+(NO3)">NO2+NO3</option> 
                                                        -->
                                                        <option value="Dissolved oxygen (DO)" selected="selected">Dissolved Oxygen (DO)</option>
                                                        <option value="Temperature, water">Temperature, water</option>
                                                        <option value="pH">pH</option>
                                                        <option value="Turbidity">Turbidity</option>
                                                        <option value="Escherichia coli">E-coli</option>  
                                                        <option value="Phosphorus">Phosphorus</option> 
                                                        <option value="Nitrogen, mixed forms (NH3), (NH4), organic, (NO2) and (NO3)">NO2+NO3</option> 
                                                    </select>
                                                </div>
                                                <div class="col-sm-2">
                                                    <input  id="beginDateInput"   class="form-control"  placeholder="Begin Date" title="Begin Date"  />
                                                </div>
                                                <div class="col-sm-2">
                                                    <input  id="endDateInput"   class="form-control"  placeholder="End Date" title="End Date"  />
                                                </div>
                                                <div class="col-sm-2">
                                                    <%-- <asp:TextBox ID="lowThreshInput" runat="server" CssClass="form-control"
                                                                 placeholder="Lower Threshold" title="Lower Threshold"></asp:TextBox>--%>
                                                    <input id="longInput" style="display:none"/>
                                                    <input id="latInput" style="display:none"/>
                                                   <%-- <span class="fldLbl"> Lower Threshold: </span>--%>
                                                    <input  id="lowThreshInput"   class="form-control"  placeholder="Lower Threshold" title="Lower Threshold"  />
                                                </div>
                                                <div class="col-xs-2">
                                                    <%-- <asp:TextBox ID="highThreshInput" runat="server" CssClass="form-control"
                                                                 placeholder="Upper Threshold" title="Upper Threshold"></asp:TextBox>--%>
        
                                                    <input  id="highThreshInput"   class="form-control"  placeholder="Upper Threshold" title="Upper Threshold"  />         
                                                </div>
                                            </div>
                                            <br/>
                                            <div class="row">
                                                <input id="extentBBox" style="display:none" />
                                                <input id="parameterBBox" style="display:none" />
                                                <input id="parameterSiteIDs" style="display:none" />
                                                <input id="allOrganizationShown" style="display:none"/>

                                                <span id="searchQueryDisplay" style="display: none;"></span>
                                                <img id="progressImg" src="/App_Images/progress.gif" style="display: none; position:absolute; right:512px; top:386px; z-index:100; height:30px; width:30px;" />           
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="map">
                            </div>
                        </div>
            <%--//////////////////////////////////////////--%>
                        <div id="pane2" class="tab-pane">
                            <div class="row">
                                <div class="col-sm-12">
                                    <br/>
                                    <button id="checkAllBtn" type="button">Select All</button>
                                    <button id="uncheckAllBtn" type="button">Deselect All</button>
                           

                                    </div>
                             
                            </div>


                           <div class="row">
                                <div class="col-sm-12">
                                   
                                    <div class="panel-group" id="accordion"></div>
                                </div>
                            </div>




                        </div>
            <%--//////////////////////////////////////////--%>
                        <div id="pane3" class="tab-pane">
                             <div class="row">
                                 <div class="col-sm-12">
                                    <p><b>Analyze</b></p> 
                                    <label><input type="radio" name="RadioAnalyze" value="map" id="RadioAnalyze_box" checked="checked"/>Box Whisker Plot</label>
                                    <label><input type="radio" name="RadioAnalyze" value="text" id="RadioAnalyze_trends"/>Trend Analysis</label>
                                        <input  id="lowThreshChartsInput"   class="form-control" placeholder="Lower Threshold" title="Lower Threshold"  onchange="setThreshold()"/>
                                         <input  id="upperThreshChartsInput"   class="form-control"  placeholder="Upper Threshold" title="Upper Threshold"  onchange="setThreshold()"/>
              
                                    <br/>Water Quality Parameter: <span class="selectedWaterParameter"></span><br/>
             
                                     <div id="analyzeBoxArea">
                                         <p><b>Box Whisker Plot:</b></p>
                                         <div id="boxWhiskerPlot"></div>
                                     </div>
                                     <div id="analyzeTrendsArea" style="display:none;">
                                         <p><b>Trend Analysis:</b></p>
                                         <div style="width:500px;">
                                         <!--<input  id="lowThreshChartsInput"   class="form-control" placeholder="Lower Threshold" title="Lower Threshold"  />
                                         <input  id="upperThreshChartsInput"   class="form-control"  placeholder="Upper Threshold" title="Upper Threshold"  />
              
                                         <button id="updateChartThreshBtn" type="button" onclick="resultChecked();">Update Chart Thresholds</button>-->
                                         </div><br/>
                                         <div id="trendChartsMaster"></div>
                                         <div id="trendCharts"></div>
                                         <!--TESTING-->
                                    <!-- /.carousel <div id="carouselDiv" style="height:500px">
                                        <div id="myCarousel" class="carousel slide" style="height:500px" data-ride="carousel">
                                          
                                          <ol id="carouselol" class="carousel-indicators">
                                            <li id="carouselPlaceholderLi" data-target="#myCarousel" data-slide-to="0" class="active"></li>
                                          </ol>
                                          <div id="carouselInner" class="carousel-inner" style="height:inherit">
                                            <div id="carouselPlaceholderDiv" class="item active" style="height:inherit; ">
                                              <div class="container">
                                                <div class="carousel-caption">
                                                  <h1>END</h1>
                                                  <p></p>
                                                  <p></p>
                                                </div>
                                              </div>
                                            </div>
                                          </div>
                                          <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
                                          <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
                                        </div>
                                    </div>-->
                                     </div>
                                 </div>
                             </div>
                        </div>
                        <div id="pane4" class="tab-pane">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div id="tabsReport">
                                        <p><b>Report</b></p>     
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="pane5" class="tab-pane">
                           <div class="row">
                             <div class="col-sm-12">
                                <div id="saveTabsReport">
                                    <p><b>Config</b></p>     
                                </div>
                              </div>
                          </div>
                        </div>
                    </div>                                
                </div>
            </div>
        </div>
    </div>
</div>
</asp:Content>
