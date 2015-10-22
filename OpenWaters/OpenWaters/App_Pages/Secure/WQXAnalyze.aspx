<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXAnalyze.aspx.cs" Inherits="OpenEnvironment.App_Pages.Secure.WQXAnalyze" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <style type="text/css">

          html,body{
            height:100%;
        }


        #map{
            height:600px;
            width:100%;
        }
        h2{
            margin: 0;     
            color: #666;
            padding-top: 90px;
            font-size: 52px;
            font-family: "trebuchet ms", sans-serif;    
        }
        .item{
            background: #333;    
            text-align: center;
            height: 300px !important;
        }
        .carousel{
            /*margin-top: 20px;*/
        }

        .contentArea {
          margin-top: 5.5em;
        }

        </style>



       <script type="text/javascript">

	 



	    // Load the Visualization API and the piechart package.
	    google.load('visualization', '1.0', { 'packages': ['corechart'] });

	    // Set a callback to run when the Google Visualization API is loaded.
	    // google.setOnLoadCallback(drawChart);
	
        
	    var map;
	    var defaultSymbol, highlightSymbol;
        require([
          "esri/map", "esri/dijit/BasemapGallery", "esri/arcgis/utils",
          "dojo/parser", "esri/layers/GraphicsLayer", "esri/graphic", "esri/geometry/Point", "esri/symbols/SimpleMarkerSymbol",
          "esri/Color", "esri/InfoTemplate", "dojo/_base/array", "esri/geometry/Multipoint", "esri/SpatialReference",
          "esri/geometry/webMercatorUtils",
          "dijit/layout/BorderContainer", "dijit/layout/ContentPane", "dijit/TitlePane", "dojo/on",
          "dojo/domReady!"
        ], function (
          Map, BasemapGallery, arcgisUtils,
          parser,
          GraphicsLayer, Graphic, Point, SimpleMarkerSymbol,
          Color, InfoTemplate, arrayUtils, MultiPoint, SpatialReference,
          webMercatorUtils
        ) {
            parser.parse();
            
            map = new Map("map", {
                basemap: "national-geographic",
                center: [-83.82678, 35.46913],
                zoom: 10
            });

            map.on("extent-change", extentHandler);

            //add the basemap gallery, in this case we'll display maps from ArcGIS.com including bing maps
            var basemapGallery = new BasemapGallery({
                showArcGISBasemaps: true,
                map: map
            }, "basemapGallery");
            basemapGallery.startup();

            basemapGallery.on("error", function (msg) {
                console.log("basemap gallery error:  ", msg);
            });

            //PageMethods.GetSites(OnGetSitesComplete);

            defaultSymbol = new SimpleMarkerSymbol().setColor(new Color([0, 0, 255]));
            highlightSymbol = new SimpleMarkerSymbol().setColor(new Color([255, 0, 0]));
            
        });

        function OnGetSitesComplete(result, userContext, methodName) {
            var locs = [];
            for (var i = 0; i < result.length; i++) {
                splits = result[i].split("|");
                var loc = { xloc: splits[1], yloc: splits[0], name: splits[2].split("-")[0], type: splits[2].split("-")[1] };
                locs.push(loc);
            }
            //console.log(locs);
            
            placeGraphics(locs, true);

        }


        //testGraphics();
        var gl;
            
        function graphicClicked(evt) {
            var long = evt.graphic.geometry.x;
            var lat = evt.graphic.geometry.y;
            $("#latInput").val(lat);
            $("#longInput").val(long);
        }

        function placeGraphics(locs, setExtent) {
            require(["esri/geometry/Multipoint", "esri/SpatialReference","esri/layers/GraphicsLayer","dojo/_base/array",
                    "esri/geometry/Point", "esri/symbols/SimpleMarkerSymbol", "esri/Color", "esri/InfoTemplate", "esri/graphic"], 
            function(Multipoint, SpatialReference, GraphicsLayer, arrayUtils,
                    Point, SimpleMarkerSymbol, Color, InfoTemplate, Graphic)
            {
                if(gl){
                    map.removeLayer(gl);
                }
                gl = new GraphicsLayer();
                gl.on('click', graphicClicked);
                var multiPoint = new Multipoint(new SpatialReference(4326));

                //                var locs = [{ xloc: -84.7300, yloc: 38.9700, county: 'boone' },
                //            { xloc: -84.5400, yloc: 38.9300, county: 'kenton' },
                //            { xloc: -84.3800, yloc: 38.9500, county: 'campbell' }
                //                ];

                arrayUtils.forEach(locs, function (entry) {
                    var xloc = entry.xloc;
                    var yloc = entry.yloc;
                    //console.log(xloc + " : " + yloc);

                    //var pt = new Point(xloc, yloc, new SpatialReference(4326));
                    var pt = new Point(xloc, yloc, new SpatialReference(4326));
                    multiPoint.addPoint(pt);
                    

                    var attr = { "Xcoord": xloc, "Ycoord": yloc, "Name": entry.name, "Type": entry.type, "locID": entry.locID };
                    var infoTemplate = new InfoTemplate("Water Monitoring Station", "Name:${Name} <br/>Type:${Type}");

                    var graphic = new Graphic(pt, defaultSymbol, attr, infoTemplate);
                    gl.add(graphic);
                });
                map.addLayer(gl);
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
        function plotPoints() {
            
            var queryURL = 'http://www.waterqualitydata.us/Station/search?bBox=' + $("#extentBBox").val() + '&organization=' + $("#parameterOrganization").val() + '&characteristicName=' + $("#parameterSelect").val() + '&sampleMedia=Water&mimeType=xml';
            //console.log(queryURL);
            $.ajax({
                type: 'GET',
                dataType: 'xml',
                timeout: 60000,
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
                        require(["dojo/_base/array"], function(arrayUtils){
                            arrayUtils.forEach(xmlDoc.getElementsByTagName("Organization")[0].getElementsByTagName("MonitoringLocation"), function (entry) {
                                var monitoringLoc = entry.getElementsByTagName("MonitoringLocationGeospatial")[0];
                                var long = monitoringLoc.getElementsByTagName("LongitudeMeasure")[0].childNodes[0].nodeValue;
                                var lat = monitoringLoc.getElementsByTagName("LatitudeMeasure")[0].childNodes[0].nodeValue;
                                var site = entry.getElementsByTagName("MonitoringLocationIdentity")[0];
                                
                                var locName = site.getElementsByTagName("MonitoringLocationName")[0].childNodes[0].nodeValue;
                                var locType = site.getElementsByTagName("MonitoringLocationTypeName")[0].childNodes[0].nodeValue;
                                var locId = site.getElementsByTagName("MonitoringLocationIdentifier")[0].childNodes[0].nodeValue;
                                
                                var loc = { xloc: long, yloc: lat, name: locName, type: locType, locID: locId };
                                locs.push(loc);
                               
                            });
                        });
                        
                        placeGraphics(locs, false);
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
        function enableDraw() {
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
                if ($('#selectType').val() == 'EXTENT') {
                    tb.activate(Draw.EXTENT);
                } else {
                    tb.activate(Draw.POLYGON);
                }
                
            });
        }

        function clearUserSelection() {
            while (document.getElementById("resultsTable").rows.length > 1) {
                document.getElementById("resultsTable").deleteRow(1);
            }
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
                        graphic.setSymbol(defaultSymbol);
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
                            graphic.setSymbol(defaultSymbol);
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
    </script>
   
<div class="contentArea">
        <div class="row">
            <div class="col-sm-12"> 
                <ajaxToolkit:ToolkitScriptManager ID="scriptManager" runat="server" AsyncPostBackTimeout="99999999" EnablePageMethods="true" />      
  
        
          <div  id="tabsSearch">
            <p><b>Search</b></p>     

             <table  border="0">
                <tr>
                    <td>Orginization:</td>
                    <td>  
                    <select id="parameterOrganization">
                          <option value="EBCI" selected="selected">EBCI</option>
                      </select>
                     </td>
                    <td>Characteristic:</td>
                    <td>  
                    <select id="parameterSelect">
                          <option value="Dissolved+oxygen+(DO)" selected="selected">Dissolved Oxygen (DO)</option>
                          <option value="Temperature%2C+water">Temperature, water</option>
                          <option value="pH">pH</option>
                          <option value="Turbidity">Turbidity</option>
                          <option value="Escherichia+coli">E-coli</option> 
                          <option value="Phosphorus">Phosphorus</option>  
                          <option value="Nitrogen%2C+mixed+forms+(NH3)%2C+(NH4)%2C+organic%2C+(NO2)+and+(NO3)">NO2+NO3</option> 
                      </select>
                     </td>
                     <td>Begin Date:</td>
                     <td><input  id="beginDateInput"/></td>
                     <td>End Date:</td>
                     <td><input  id="endDateInput"/></td>
                 </tr>
             </table>

             <table  border="0">
                <tr>
                   <!-- <td><label for="countySelect">State:</label></td>
                    <td>
                          <div id="stateSelectWrapper"><select id="stateSelect"></select></div>
                    </td>
                    <td><label for="countySelect">County:</label></td>
                    <td>
                          <div id="countySelectWrapper"><select id="countySelect"></select></div>
                    </td>
                     <td>FIPS:</td>
                      <td>
                         <span id="fipsDisplay"></span>
                    </td>-->
                    <td style="display:none"><input id="longInput"/><input id="latInput"/></td>
                    <td>Lower Threshold:</td>
                    <td>
                          <input  id="lowThreshInput"/>
                    </td>
                    <td>Upper Threshold:</td>
                    <td>
                          <input  id="highThreshInput"/>
                    </td>
                 </tr>
  
             </table>
            <input id="extentBBox" style="display:none" />
            <input id="parameterBBox" style="display:none" />
            <input id="parameterSiteIDs" style="display:none" />
            <button id="showSites" type="button" onclick="plotPoints();">Show Monitoring Locations</button>
            <button id="selectArea" type="button" onclick="enableDraw();">Select Region</button>
            <select id="selectType"><option value="EXTENT">Rectangle</option><option value="POLYGON">Polygon</option></select>
            <button id="clearSelection" type="button" onclick="clearUserSelection();">Clear Selection</button>
            <div id="searchQueryDisplay" style="display: none;"></div>
            <img id="progressImg" src="/App_Images/progress.gif" style="display: none; position:absolute; right:512px; top:386px; z-index:100; height:30px; width:30px;" />
            
<%--            <div data-dojo-type="dijit/layout/BorderContainer" 
                data-dojo-props="design:'headline', gutters:false" 
                style="width:100%;height:100%;margin:0;">--%>

                
        <%--    </div>--%>
            <button id="submitUsetTaskBtn" type="button">Submit Task</button>
            <button id="checkAllBtn" type="button">Select All</button>
            <button id="uncheckAllBtn" type="button">Deselect All</button>
            <div id="loading" style="display: none;">
                Loading... 
            </div>
            <table id="resultsTable"   border="0" style="max-width:1024px;">
                <tr>
                    <td></td>
                    <td style="text-decoration:underline">Date:</td>
                    <td style="text-decoration:underline">Measured Value:</td>
                    <td style="text-decoration:underline">Units:</td>
                    <td style="text-decoration:underline">Location:</td>
                 </tr>
             </table>
            
            </div>
          </div>
          </div>

<div class="row">
<div class="col-sm-12"> 
 
    <div id="myCarousel" class="carousel slide"  data-ride="carousel">
    	<!-- Carousel indicators -->
        <ol class="carousel-indicators">
            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#myCarousel" data-slide-to="1"></li>
            <li data-target="#myCarousel" data-slide-to="2"></li>
        </ol>   
       <!-- Carousel items -->
        <div class="carousel-inner">
            <div class="active item">
               
                  <div id="map" ></div>
               
               
            </div>

            <div class="item">
                <h2>Slide 2</h2>
                <div class="carousel-caption">
                  <h3>Second slide label</h3>
                  <p>Aliquam sit amet gravida nibh, facilisis gravida odio.</p>
                </div>
            </div>
            <div class="item">
                <h2>Slide 3</h2>
                <div class="carousel-caption">
                  <h3>Third slide label</h3>
                  <p>Praesent commodo cursus magna, vel scelerisque nisl consectetur.</p>
                </div>
            </div>
        </div>
        <!-- Carousel nav -->
        <a class="carousel-control left" href="#myCarousel" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left"></span>
        </a>
        <a class="carousel-control right" href="#myCarousel" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right"></span>
        </a>
    </div>
</div> 
</div>
</div>
</asp:Content>

