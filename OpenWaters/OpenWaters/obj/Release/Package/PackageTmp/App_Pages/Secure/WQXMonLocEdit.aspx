<%@ Page Title="TFerst Mvskogee Open Waters - Mon Loc Details" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXMonLocEdit.aspx.cs" Inherits="OpenEnvironment.WQXMonLocEdit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    
    
     <asp:ObjectDataSource ID="dsRefData" runat="server" SelectMethod="GetT_WQX_REF_DATA" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref">
        <SelectParameters>
            <asp:Parameter DefaultValue="MonitoringLocationType" Name="tABLE" Type="String" />
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
            <asp:Parameter DefaultValue="true" Name="UsedInd" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <div class="contentArea">

    <h2>
        Edit Monitoring Location
    </h2>
    <p>
        <asp:Label ID="lblMsg" runat="server" CssClass="failureNotification"></asp:Label>
        <asp:Label ID="lblMonLocIDX" runat="server" Style="display:none"/>
    </p>
    <div class="panel panel-default" >
    <div class="panel-body" >


       <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtMonLocID" placeholder="Mon Loc ID" ToolTip="Mon Loc ID" runat="server" Width="250px" CssClass="form-control" MaxLength="35"></asp:TextBox>
        </div></div>
       <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtMonLocName"  placeholder="Mon Loc Name" ToolTip="Mon Loc Name"  Width="250px" runat="server" CssClass="form-control" MaxLength="255"></asp:TextBox>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Mon Loc Type:</p>
            <asp:DropDownList ID="ddlMonLocType"  placeholder="Mon Loc Type" ToolTip="Mon Loc Type" runat="server" CssClass="form-control" ></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtMonLocDesc" placeholder="Mon Loc Desc" ToolTip="Mon Loc Desc" runat="server" Width="250px"  CssClass="form-control" ></asp:TextBox>
        </div></div>
       <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtHUC8" placeholder="8-Digit HUC" ToolTip="8-Digit HUC" MaxLength="8" runat="server" Width="250px"  CssClass="form-control"></asp:TextBox>
        </div></div>
       <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtHUC12" placeholder="12-Digit HUC" ToolTip="12-Digit HUC" MaxLength="12" runat="server" Width="250px"  CssClass="form-control"></asp:TextBox>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>On Tribal Land?:
            <asp:CheckBox ID="chkLandInd" runat="server" CssClass="fldTxt" /></p>
            <asp:TextBox ID="txtLandName" runat="server" Width="250px" MaxLength="200" CssClass="form-control"></asp:TextBox>
        </div></div>
       <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtLatitude" runat="server" placeholder="Latitude" ToolTip="Latitude" Width="104px" MaxLength="12"  CssClass="form-control"></asp:TextBox>
            <asp:TextBox ID="txtLongitude" runat="server" placeholder="Longitude" ToolTip="Longitude" Width="104px" MaxLength="14"  CssClass="form-control"></asp:TextBox>
            <asp:ImageButton ID="btnMap" runat="server" ImageUrl="~/App_Images/ico_map.png" PostBackUrl="http://maps.google.com/?q=-37.866963,144.980615" />
        </div></div>
       <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtSourceMapScale" placeholder="Source Map Scale" ToolTip="Source Map Scale" MaxLength="12" runat="server" Width="250px"  CssClass="form-control"></asp:TextBox>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Horiz. Collection Method</p>
            <asp:DropDownList ID="ddlHorizMethod" runat="server" CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Horiz. Reference Datum</p>
            <asp:DropDownList ID="ddlHorizDatum" runat="server" CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtVertMeasure" runat="server" placeholder="Vertical Measure" ToolTip="Vertical Measure" Width="250px" MaxLength="12"  CssClass="form-control"></asp:TextBox>
       </div></div>
       <div class="form-group"><div class="input-group">     
            <p>Unit:</p>
       <asp:DropDownList ID="ddlVertUnit" runat="server" CssClass="form-control"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Vert. Collection Method</p>
            <asp:DropDownList ID="ddlVertMethod" runat="server" CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Vert. Reference Datum</p>
            <asp:DropDownList ID="ddlVertDatum" runat="server" CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Country</p>
            <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>State</p>
            <asp:DropDownList ID="ddlState" runat="server" OnSelectedIndexChanged="ddlState_SelectedIndexChanged" AutoPostBack="true" CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>County</p>
            <asp:DropDownList ID="ddlCounty" runat="server" CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Well Type</p>
            <asp:DropDownList ID="ddlWellType" runat="server" CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Active?</p>
            <asp:CheckBox ID="chkActInd" runat="server" CssClass="fldTxt" />
        </div></div>
       <div class="form-group"><div class="input-group">
            <p>Send to EPA</p>
            <asp:CheckBox ID="chkWQXInd" runat="server" CssClass="fldTxt" />
        </div></div>
        <br />
        <div class="btnRibbon">
            <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="Save &amp; Exit" onclick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" Text="Cancel" onclick="btnCancel_Click" />
        </div>

    </div>
    </div>


    </div>
    
</asp:Content>
