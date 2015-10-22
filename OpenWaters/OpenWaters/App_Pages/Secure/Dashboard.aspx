<%@ Page Title="TFerst Mvskogee Open Waters - Dashboard" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="OpenEnvironment.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

     <style>
        .btn{

        margin:2px;
        margin-left:4px;
        }

       .row{

        margin:10px;
     

        }

        #map {
        height:225px;
        max-height: 225px; 
        width: 100%;

      }



        #importDashboard {

            height:200px;
        }

    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">    
    
    <script type="text/javascript">
        $(document).ready(function ($) {
            $('#signup_1').hide();

            if ($('#ctl00_MainContent_spnWiz1').attr('class') != 'signup_header_check')
                $('#signup_1').show();
            else if ($('#ctl00_MainContent_spnWiz2').attr('class') != 'signup_header_check')
                $('#signup_2').show();
            else if ($('#ctl00_MainContent_spnWiz3').attr('class') != 'signup_header_check')
                $('#signup_3').show();
            else if ($('#ctl00_MainContent_spnWiz4').attr('class') != 'signup_header_check')
                $('#signup_4').show();
            else if ($('#ctl00_MainContent_spnWiz5').attr('class') != 'signup_header_check')
                $('#signup_5').show();
            else if ($('#ctl00_MainContent_spnWiz6').attr('class') != 'signup_header_check')
                $('#signup_6').show();



            $('#signup_steps').find('.ui-accordion-header').click(function () {
                $(this).next().slideToggle('fast');
                //hide the other panels
                $(".ui-accordion-content").not($(this).next()).slideUp('fast');
            });
        });

        </script>
        
        <script type="text/javascript" src="../../js/plugins/bootstra-wizard/jquery.bootstrap.wizard.min.js"></script>
        
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

     <ajaxToolkit:ToolkitScriptManager ID="scriptManager" runat="server" AsyncPostBackTimeout="99999999" EnablePageMethods="true" />        
    
    <asp:ObjectDataSource ID="dsProject" runat="server" SelectMethod="GetWQX_PROJECT" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_WQX">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
            <asp:SessionParameter DefaultValue="" Name="OrgID" SessionField="OrgID" Type="String" />
            <asp:Parameter DefaultValue="false" Name="WQXPending" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>



      <div class="page-content">

                  <div class="page-toolbar">
                        
                        <div class="page-toolbar-block">
                          
                              <div class="page-toolbar-title">Dashboard</div>
                          
                        </div>


                       <!--<div class="page-toolbar-block pull-right">
                          <span style="padding-left:25px; padding-right:25px; font-size:14pt;">                       
                          <a href="https://trello.com/b/zg3scx88/open-waters-mobile-development">Track Development</a> 
                          </span>  
                        </div>  -->


                       <!--<div class="page-toolbar-block pull-right">
                          <span style="padding-left:25px; padding-right:25px; font-size:14pt;">                       
                          <a href="#">Automated Testing</a> 
                          </span>  
                        </div> -->   
                        
         
                        
                    </div>         

          </div>




          <div class="row" >
          <div class="col-sm-6 col-md-6" >
              <asp:Panel ID="pnlOrgSpecific" runat="server" Visible="false">
                     
                            <div class="block">                          
                             <div class="block-head">
                                    <h2>TFerst Mvskogee Open Waters Summary Dashboard - <%=Session["OrgID"] %></h2>
                                  <ul class="buttons">
                                       <%-- <li><a href="#" class="block-refresh"><span class="fa fa-refresh"></span></a></li>
                                        <li><a href="#" class="block-toggle"><span class="fa fa-chevron-down"></span></a></li>
                                        <li><a href="#" class="block-remove"><span class="fa fa-times"></span></a></li>--%>
                                    </ul>  
                                </div>


        <div class="block-content">

        <table class="table table-condensed" >
           
           <thead>
                <tr>
                    <td>Data Collection Metrics</td>             
                </tr>
           </thead>

           <tbody>

               <tr>
               <td><div class="fldLbl" style="width:250px; ">Organizations Using TFerst Mvskogee Open Waters: </div></td>
               <td><asp:Label ID="lblOrgName" runat="server" CssClass="bold"></asp:Label></td>
               </tr>
              
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
                    <td> <asp:Label ID="lblSamp" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
                 <tr>
                    <td><a href="WQXActivity.aspx">Number of Results: </a></td>
                    <td><asp:Label ID="lblResult" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
                <tr>
                    <td><a href="WQX_Mgmt.aspx">Samples Pending Transfer to EPA:</a></td>
                    <td><asp:Label ID="lblSampPend2" runat="server" CssClass="fldTxt" style="font-weight:bold" ></asp:Label></td>
                </tr>
            </tbody>
        </table>                 
       </div> 
       </div>  
       
       </asp:Panel>
       </div> 
             
       <div class="col-sm-6 col-md-6">
                            <div class="block">                          
                             <div class="block-head">
                                    <h2>Monitoring Locations Map - <%=Session["OrgID"] %></h2>
                                  <ul class="buttons"></ul>  
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
    </div>
       

  <div class="row" >

  <!--<div class="block">                          
                             <div class="block-head">
                                    <h2>Getting Started</h2>
                                  <ul class="buttons"></ul>  
                              </div>

       
            

       
       <div class="col-sm-6 col-md-6">
                    
       
                    <div class="block-content"> 
                   <asp:Panel ID="pnlAdminTasks" runat="server" CssClass="form-control"  Visible="false">
                        <div>Admin Tasks</div><br />
                        <div class="indent">
                            <div class="row">
                                <asp:Label ID="lblAdminMsg" runat="server" CssClass="failureNotification"></asp:Label>
                            </div>
                            <asp:Panel ID="pnlPendingUsers" runat="server" CssClass="indent">
                                <h3>Pending Users Requiring Your Approval</h3>
                                <asp:GridView ID="grdPendingUsers" runat="server" CssClass="grd" PagerStyle-CssClass="pgr" AutoGenerateColumns="False"  
                                    AlternatingRowStyle-CssClass="alt" onrowcommand="grdPendingUsers_RowCommand" >
                                    <Columns>
                                        <asp:TemplateField HeaderText="Approve">
                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ApproveButton" runat="server" CausesValidation="False" CommandName="Approve"
                                                    CommandArgument='<% #Eval("USER_IDX")+","+ Eval("ORG_ID") %>' ImageUrl="~/App_Images/ico_pass.png" ToolTip="Approve" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Reject">
                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                            <ItemTemplate>
                                                <asp:ImageButton ID="RejectButton" runat="server" CausesValidation="False" CommandName="Reject"
                                                    CommandArgument='<% #Eval("USER_IDX")+","+ Eval("ORG_ID") %>' ImageUrl="~/App_Images/ico_fail.png" ToolTip="Reject" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="USER_ID" HeaderText="User ID" SortExpression="USER_ID" />
                                        <asp:BoundField DataField="ORG_ID" HeaderText="Organization" SortExpression="ORG_ID" />
                                    </Columns>
                                </asp:GridView>
                            </asp:Panel>
                            <br />
                        </div>
                   </asp:Panel>
                    </div>

                </div>-->

       <div class="col-sm-6 col-md-6">
           <!--
                <div class="block-content" > 
                    <div class="brdr-green success" style="min-width:350px; background-color: #8ec165;" >
                        <div class="ie9roundedgradient"><div class="rndPnlTop-green">Getting Started Guide</div></div>
                        <div class="indent" >

                            <div class="block-content"> 
                            <!-- GETTING STARTED WIZARD --><!--
                            <div id="signup_steps" class="ui-accordion ui-helper-reset ">
                                <h3 class="ui-accordion-header ui-helper-reset ui-corner-all"><span class="ui-icon ui-icon-exp">1</span>
                                    <a target="_blank">
                                        <span class="signup_tabs_header ">Create or Join an Organization</span>
                                        <span id="spnWiz1" runat="server" class=""></span>
                                    </a>
                                </h3>
                                <div class="signup_container infoSlide ui-accordion-content ui-helper-reset ui-corner-bottom" id="signup_1" style="height: 80px; overflow: auto; padding-top: 13px; padding-bottom: 13px; display: block;">
                                    <span >
                                        <asp:Label ID="lblWiz1" runat="server" CssClass="left" Width="450px" ></asp:Label>
                                        <asp:Button ID="btnWiz1" runat="server" Text="Get Started" CssClass="btn right" OnClick="btnWiz1_Click"  />
                                    </span>
                                </div>

                                <h3 class="ui-accordion-header ui-helper-reset ui-corner-all"><span class="ui-icon ui-icon-exp">2</span>
                                    <a target="_blank">
                                        <span class="signup_tabs_header">Authorize TFerst Mvskogee Open Waters to Submit Data</span>
                                        <span id="spnWiz2" runat="server" class=""></span>
                                    </a>
                                </h3>
                                <div class="signup_container infoSlide ui-accordion-content ui-helper-reset ui-corner-bottom" id="signup_2" style="height: 80px; overflow: auto; padding-top: 13px; padding-bottom: 13px; display: none;">
                                    <asp:Label ID="lblWiz2" runat="server" CssClass="left" Width="450px" Text="In order to submit data to EPA using TFerst Mvskogee Open Waters, you must contact EPA and request that they authorize Open Waters to submit data."></asp:Label>
                                    <asp:Button ID="btnWiz2" runat="server" Text="Get Started" CssClass="btn right" OnClick="btnWiz2_Click" />
                                </div>

                                <h3 class="ui-accordion-header ui-helper-reset ui-corner-all"><span class="ui-icon ui-icon-exp">3</span>
                                    <a target="_blank">
                                        <span class="signup_tabs_header">Enter 1 or more monitoring locations</span>
                                        <span id="spnWiz3" runat="server" class=""></span>
                                    </a>
                                </h3>
                                <div class="signup_container infoSlide ui-accordion-content ui-helper-reset ui-corner-bottom" id="signup_3" style="height: 80px; display: none; overflow: auto; padding-top: 13px; padding-bottom: 13px;">
                                    <asp:Label ID="lblWiz3" runat="server" CssClass="left" Width="450px" Text="After you create an organization, you can then enter or import monitoring locations." ></asp:Label>
                                    <asp:Button ID="btnWiz3" runat="server" Text="Enter" CssClass="btn right" OnClick="btnWiz3_Click"  />                                    
                                    <asp:Button ID="btnWiz3b" runat="server" Text="Import" CssClass="btn right" OnClick="btnWiz4b_Click"  />
                                </div>

                                <h3 class="ui-accordion-header ui-helper-reset ui-corner-all"><span class="ui-icon ui-icon-exp">4</span>
                                    <a target="_blank">
                                        <span class="signup_tabs_header">Enter 1 or more projects</span>
                                        <span id="spnWiz4" runat="server" class=""></span>
                                    </a>
                                </h3>
                                <div class="signup_container infoSlide ui-accordion-content ui-helper-reset ui-corner-bottom" id="signup_4" style="height: 80px; overflow: auto; padding-top: 13px; padding-bottom: 13px; display: none;">
                                    <asp:Label ID="lblWiz4" runat="server" CssClass="left" Width="450px" Text="After you create an organization, you can then enter or import projects." ></asp:Label>
                                    <asp:Button ID="btnWiz4" runat="server" Text="Enter" CssClass="btn right" OnClick="btnWiz4_Click"  />
                                    <asp:Button ID="btnWiz4b" runat="server" Text="Import" CssClass="btn right" OnClick="btnWiz4b_Click"  />
                                </div>

                                <h3 class="ui-accordion-header ui-helper-reset ui-corner-all"><span class="ui-icon ui-icon-exp">5</span>
                                    <a target="_blank">
                                        <span class="signup_tabs_header">Pick default settings for your Organization</span>
                                        <span id="spnWiz5" runat="server" class=""></span>
                                    </a>
                                </h3>
                                <div class="signup_container infoSlide ui-accordion-content ui-helper-reset ui-corner-bottom" id="signup_5" style="height: 80px; overflow: auto; padding-top: 13px; padding-bottom: 13px; display: none;">
                                    <asp:Label ID="lblWiz5" runat="server" CssClass="left" Width="450px" Text="After you create an organization, you can then pick default settings for your organization (e.g. which Characteristics you will sample, default TimeZone, etc) that can aid in faster data entry." ></asp:Label>
                                    <asp:Button ID="btnWiz5" runat="server" Text="Get Started" CssClass="btn right" OnClick="btnWiz5_Click"  />
                                </div>

                                <h3 class="ui-accordion-header ui-helper-reset ui-corner-all"><span class="ui-icon ui-icon-exp">6</span>
                                    <a target="_blank">
                                        <span class="signup_tabs_header">Enter 1 or more activites</span>
                                        <span id="spnWiz6" runat="server" class=""></span>
                                    </a>
                                </h3>
                                <div class="signup_container infoSlide ui-accordion-content ui-helper-reset ui-corner-bottom" id="signup_6" style="height: 80px; overflow: auto; padding-top: 13px; padding-bottom: 13px; display: none;">
                                    <asp:Label ID="lblWiz6" runat="server" CssClass="left" Width="450px" Text="After you create a monitoring location and project, you can then enter or import samples."></asp:Label>
                                    <asp:Button ID="btnWiz6" runat="server" Text="Enter" CssClass="btn right" OnClick="btnWiz6_Click"  />
                                    <asp:Button ID="btnWiz6b" runat="server" Text="Import" CssClass="btn right" OnClick="btnWiz4b_Click"  />
                                </div>
                            </div>
                            </div>
      -->
                        </div>
                        <div id="clear" style="clear:both;"></div>
                    </div>
            </div>
          </div>
    </div>
    </div>
  
</asp:Content>
