<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXESRIMap.aspx.cs" Inherits="OpenEnvironment.App_Pages.Secure.WQXESRIMap" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">



  <link rel="stylesheet" type="text/css" href="//js.arcgis.com/3.8/js/esri/css/esri.css">

  <script type='text/javascript' src="//js.arcgis.com/3.8"></script>
    
  
  <style type='text/css'>
    html,body{
    height:100%;
}

.row,.container-fluid{
    height:100%;
}

#map{
    height:100%;
    width:100%;
}
  </style>

    <script type='text/javascript'>//<![CDATA[ 
        $(window).load(function () {
            require(["esri/map", "esri/dijit/LocateButton", ], function (Map, LocateButton) {

                var map = new Map("map", {
                    center: [-56.049, 38.485],
                    basemap: "streets",
                    zoom: 3,
                    logo: false
                });

            })
        });//]]>  

</script>


    <div class="container-fluid">
        <div class="row">
      <div id="map" ></div>
</div>
    </div><!-- /.container -->
     
    
        
</asp:Content>

