<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.master" AutoEventWireup="true" CodeBehind="WQXUploadExcel.aspx.cs" Inherits="OpenEnvironment.App_Pages.Secure.WQXUploadExcel" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="head" ContentPlaceHolderID="head" runat="server">

    <style>

        .btn{

        margin:2px;
        margin-left:4px;
        }

       .row{

        margin:4px;
     

        }

    



        #importDashboard {

            height:200px;
        }

     


    </style>






        
  <script>

      var boolBC = false;



      function AddData() {
          $('#datUploadResults').show();
      }

      function RemoveData() {
          $('#datUploadResults').hide();
          boolBC = false;

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

    <script type="text/javascript">
        $(function () {
            $('.list-group.checked-list-box .list-group-item').each(function () {

                // Settings
                var $widget = $(this),
                    $checkbox = $('<input type="checkbox" class="hidden" />'),
                    color = ($widget.data('color') ? $widget.data('color') : "primary"),
                    style = ($widget.data('style') == "button" ? "btn-" : "list-group-item-"),
                    settings = {
                        on: {
                            icon: 'glyphicon glyphicon-check'
                        },
                        off: {
                            icon: 'glyphicon glyphicon-unchecked'
                        }
                    };

                $widget.css('cursor', 'pointer')
                $widget.append($checkbox);

                // Event Handlers
                $widget.on('click', function () {
                    $checkbox.prop('checked', !$checkbox.is(':checked'));
                    $checkbox.triggerHandler('change');
                    updateDisplay();
                });
                $checkbox.on('change', function () {
                    updateDisplay();
                });


                // Actions
                function updateDisplay() {
                    var isChecked = $checkbox.is(':checked');

                    // Set the button's state
                    $widget.data('state', (isChecked) ? "on" : "off");

                    // Set the button's icon
                    $widget.find('.state-icon')
                        .removeClass()
                        .addClass('state-icon ' + settings[$widget.data('state')].icon);

                    // Update the button's color
                    if (isChecked) {
                        $widget.addClass(style + color + ' active');
                    } else {
                        $widget.removeClass(style + color + ' active');
                    }
                }

                // Initialization
                function init() {

                    if ($widget.data('checked') == true) {
                        $checkbox.prop('checked', !$checkbox.is(':checked'));
                    }

                    updateDisplay();

                    // Inject the icon if applicable
                    if ($widget.find('.state-icon').length == 0) {
                        $widget.prepend('<span class="state-icon ' + settings[$widget.data('state')].icon + '"></span>');
                    }
                }
                init();
            });

            $('#get-checked-data').on('click', function (event) {
                event.preventDefault();
                var checkedItems = {}, counter = 0;
                $("#check-list-box li.active").each(function (idx, li) {
                    checkedItems[counter] = $(li).text();
                    counter++;
                });
                $('#display-json').html(JSON.stringify(checkedItems, null, '\t'));
            });
        });
	</script>


  <script src="../../Scripts/jQueryAssets/FipsCountyCodes.js" type="text/javascript"></script>


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

		        var queryURL = 'http://www.waterqualitydata.us/Station/search?bBox=' + $("#extentBBox").val() + '&characteristicName=' + $("#parameterSelect").val() + '&sampleMedia=Water&mimeType=xml';
		        if (forOrganization) {
		            queryURL += '&organization=' + $("#parameterOrganization").val();
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
		                                var site = entry.getElementsByTagName("MonitoringLocationIdentity")[0];

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
		    //function switchBasemap(e) {
		    //    switch (e) {
		    //        case "Streets":
		    //            map.setBasemap("streets");
		    //            break;
		    //        case "Imagery":
		    //            map.setBasemap("hybrid");
		    //            break;
		    //        case "National Geographic":
		    //            map.setBasemap("national-geographic");
		    //            break;
		    //        case "Topographic":
		    //            map.setBasemap("topo");
		    //            break;
		    //        case "Gray":
		    //            map.setBasemap("gray");
		    //            break;
		    //        case "Open Street Map":
		    //            map.setBasemap("osm");
		    //            break;
		    //    }
		    //}
    </script>



    
    
    </asp:Content>


    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server"> 
    <ajaxToolkit:ToolkitScriptManager ID="scriptManager" runat="server" AsyncPostBackTimeout="99999999" EnablePageMethods="true" />         

     <div class="page-content">

            <%-- <a href="#" id="btnImport" class="btn btn-primary"  data-toggle="modal" data-target="#importDashboard">Upload Data</a> --%>
                    
                <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="panel">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                  <i class="fa fa-upload fa-2x"></i>
                                </div>
                                    <a href="#" id="btnImport"   data-toggle="modal" data-target="#importDashboard">
                                    <div class="panel-footer">
                                        <span class="pull-left">Upload Data</span>
                                        <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                        <div class="clearfix"></div>
                                    </div>
                                   </a>
                            </div>
                        </div>
                 
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-cogs fa-2x"></i>
                                </div>
                                <a href="WQXConfigurations.aspx">
                                <div class="panel-footer"> 
                                <span class="pull-left">Configure Excel</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                                </div>
                                </a>
                            </div>
                        </div>
                        
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-tasks fa-2x"></i>
                                </div>
                                 <a href="ColumnAdmin.aspx">
                                <div class="panel-footer">
                                <span class="pull-left">Filter Data</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                               </div>
                               </a>
                            </div>
                        </div>
                       
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-check fa-2x"></i>
                                </div>
                                 <a href="WQXOrgEdit.aspx">
                                 <div class="panel-footer">
                                <span class="pull-left">Check Connection</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                                </div>
                                </a>
                            </div>
                        </div>
                       
                    </div>
                </div>
            </div>  
         




          <%--  <div class="page-toolbar">
                        
                        <div class="page-toolbar-block">
                       
                            <a href="#" id="btnImport" class="btn btn-primary"  data-toggle="modal" data-target="#importDashboard">Upload Data</a>
                      
                             
                             <div class="page-toolbar-title">Dashboard</div>
                          
                        </div>
                        
                        <div class="page-toolbar-block pull-right">
                            <div class="widget-info widget-from">
                                <div id="reportrange" class="dtrange">                                            
                                    <span></span><b class="caret"></b>
                                </div>                            
                            </div>
                        </div>           
                        
                    </div>         --%>
    
   

       <%-- <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary" Text="Add an Org"  />--%>
       


        <%--Add Results
             <div id="datUploadResults" hidden="hidden">
            
            --%>


 
        <div id="datUploadResults" hidden="hidden">
             <div class="row">

                  
                        <div class="col-xs-12">
                            <div  class="block">                          
                           <%--  <div class="block-head">
                                    <h2>Validate & Migrate</h2>
                                  <ul class="buttons">
                                     
                                        <li><a href="#" class="block-toggle" onclick="block_toggle()"><span class="fa fa-chevron-down"></span></a></li>
                                        <li><a href="#" class="block-remove" onclick="RemoveData()"><span class="fa fa-times"></span></a></li>
                                    </ul>  
                                </div>--%>


                <div id="closeBlkCnt" class="block-content">


             
              <input type="hidden" id="hdnPK" runat="server" />
              <input type="hidden" id="hdnAddMode" runat="server" value="false" />

               <%-- Body--%>
               
        <br />
<%-- Messages--%>

              <div id="divMessageArea" runat="server" visible="false">
                <div class="clearfix"></div>
                <div class="row messageArea">
                  <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                    <div class="well">
                      <asp:Label ID="lblMessage" runat="server" CssClass="text-warning" Text="" />
                    </div>
                  </div>
                </div>
              </div>
      
        <asp:Label ID="LblError" runat="server" Text=""></asp:Label>


             <div class="row">
                  <div class="col-xs-6">

                 <asp:DropDownList CssClass="form-control" ID="ddlMonLoc" runat="server">
                        <asp:ListItem Text="Chemical" Selected="True" Value="CHEMICAL"></asp:ListItem>
                        <asp:ListItem Text="Bio Metrics" Selected="False" Value="BIO_METRIC"></asp:ListItem>
                  </asp:DropDownList>
                  </div>
                  </div>
                  
                 <br />


             <div class="row">

<%--            <asp:Button ID="btnValidate" runat="server"
                 Text="Validate Data" 
                 CssClass="btn btn-primary" 
               
                  />--%>
 
                <asp:ObjectDataSource ID="dsProject" runat="server" SelectMethod="GetWQX_PROJECT" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_WQX">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
                        <asp:SessionParameter DefaultValue="" Name="OrgID" SessionField="OrgID" Type="String" />
                        <asp:Parameter DefaultValue="false" Name="WQXPending" Type="Boolean" />
                    </SelectParameters>
                </asp:ObjectDataSource> 
                <asp:ObjectDataSource ID="dsTemplate" runat="server" SelectMethod="GetT_OE_SAVED_COLUMN_CONFIG_TEMPLATE" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Config" />
                <asp:Label runat="server" ID="lblTemplate" Text ="Template" />
                <asp:DropDownList ID="ddlTemplate" runat="server" /><br /><br /><br />
                <asp:Label runat="server" ID="lblProject" Text ="Project" />
                <asp:DropDownList ID="ddlProject" runat="server" />
            <asp:Button ID="btnParse" runat="server"
                 Text="Migrate to Database" 
                 CssClass="btn btn-primary" 
                 onclick="Process_Click" />


          
            </div>
           
                <br />

              <div class="row">
              <div class="col-xs-6">
              Select Excel Sheet: 
              <asp:DropDownList ID="sheetCombo" CssClass="form-control"
                runat="server" 
                AutoPostBack="True" 
                OnSelectedIndexChanged="sheetCombo_SelectedIndexChanged" >
              </asp:DropDownList>
                </div>
                </div>
                <br />

            
              <div class="table-responsive">
             

              <asp:GridView ID="GridView1"  runat="server"   
              CssClass="table table-striped table-bordered"
                  >
              </asp:GridView>
              </div>
             
         

              <%--  Footer --%>


            </div>

  
        </div>
      
</div>

</div>
</div>

        <%--End Results--%>


<%--         <div class="row">
                        <div class="col-sm-6 col-md-6">
                            <div class="block">                          
                             <div class="block-head">
                                    <h2>Tribal-FERST Mvskoke Open Waters Module Summary Dashboard - <%=Session["OrgID"] %></h2>
                                  <ul class="buttons">
                                      
                                    </ul>  
                                </div>


        <div class="block-content">

        <table class="table table-condensed">
           
           <thead>
                <tr>
                    <td>Data Collection Metrics</td>             
                </tr>
           </thead>

           <tbody>
                 
                <tr>
                    <td><a href="WQXOrg.aspx">Number of Organizations: </a></td>
                    <td><asp:Label ID="lblOrg" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
             
                <tr>
                    <td><a href="WQXProject.aspx">Number of Projects: </a></td>
                    <td><asp:Label ID="lblProject2" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
                <tr>
                    <td><a href="WQXMonLoc.aspx">Number of Monitoring Location: </a></td>
                    <td><asp:Label ID="lblMonLocs" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
                <tr>
                    <td><a href="WQXActivity.aspx">Number of Samples (Activities): </a></td>
                    <td><asp:Label ID="lblSampPend2" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
                 <tr>
                    <td><a href="WQXActivity.aspx">Number of Results: </a></td>
                    <td><asp:Label ID="lblResult" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
                <tr>
                    <td><a href="WQX_Mgmt.aspx">Samples Pending Transfer to EPA:</a></td>
                    <td><asp:Label ID="lblSamp" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
            </tbody>
        </table>                 
       </div> 
       </div>  
       </div> 
             
       <div class="col-sm-6 col-md-6">
                            <div class="block">                          
                             <div class="block-head">
                                    <h2>Monitoring Locations Map - <%=Session["OrgID"] %></h2>
                                  <ul class="buttons">
                                       
                                    </ul>  
                                </div>


        <div class="block-content"> 



              <div class="widget-window">

                    <div class="window" style="padding: 0px;">
                        <div id="map"></div>
                    </div>
                                            
              </div>


             
             
        </div> 
       </div>  
       </div>      
                                         
    </div>--%>
       

                        
 <%--<div class="col-md-12">
                            
                            <div class="block">                                
                                <div class="block-head">
                                    <h2>Summary Charts</h2>
                                    <ul class="buttons">
                                        <li><a href="#" class="block-refresh"><span class="fa fa-refresh"></span></a></li>
                                        <li><a href="#" class="block-toggle"><span class="fa fa-chevron-down"></span></a></li>
                                        <li><a href="#" class="block-remove"><span class="fa fa-times"></span></a></li>
                                    </ul>  
                                </div>
                                <div class="block-content">
                                    
                                    <img src="../../App_Images/chartdemodata.jpg" />
                                </div>                                
                            </div>
 </div>--%>
     <%--  Upload Panel--%>

 
    <div class="row">

    <div class="modal fade" id="importDashboard" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
    <div class="modal-dialog">
         <div class="modal-content">
            <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true"><span class="glyphicon glyphicon-remove"></span></button>
            <h4 class="modal-title" id="myModalLabel">
            Upload Data
            </h4>
            </div>
            <div class="modal-body">

           <div class="row" >

            <div class="col-lg-6 col-md-6 col-sm-6">
              <asp:FileUpload ID="FileUpload1" runat="server" CssClass="btn btn-primary"  /> 
              <br /><a href="/App_Docs/SampleFile.xls">Sample File</a>
            </div> 
            
            <div class="col-lg-6 col-md-6 col-sm-6 text-right">
               <asp:Button runat="server" CssClass="btn btn-primary" id="UploadButton" text="Upload" onclick="UploadButton_Click" />  
            </div>
            </div>
           </div>
        </div>
    </div>
    </div>
    </div>
   <%--<div class="page-content">

                <div class="container">
                    
                    <div class="page-toolbar">
                        
                        <div class="page-toolbar-block">
                            <div class="page-toolbar-title">Vector Maps</div>
                            <div class="page-toolbar-subtitle">BE PRO - BOOTSTRAP ADMIN TEMPLATE</div>
                        </div>
                        
                        <div class="page-toolbar-block pull-right">
                            <div class="widget-info widget-from">
                                <div class="input-group" style="width: 200px;">
                                    <span class="input-group-addon"><i class="fa fa-map-marker"></i></span>
                                    <input type="text" id="vector_world_map_value" class="form-control"/>
                                </div>
                            </div>
                        </div>       
                        
                        <ul class="breadcrumb">
                            <li><a href="#">Dashboard</a></li>
                            <li><a href="#">Maps</a></li>
                            <li class="active">Vector Maps</li>
                        </ul>
                    </div>                    
                    <div class="content-wide-control">
                        <div id="vector_map" style="width: 100%; height: 100%;"></div>
                    </div>  
                </div>
            </div>
            --%>
    </div>    
</asp:Content>
