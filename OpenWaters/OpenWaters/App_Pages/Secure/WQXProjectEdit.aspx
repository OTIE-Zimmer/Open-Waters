<%@ Page Title="Tribal-FERST Mvskoke Open Waters Module - Project Details" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXProjectEdit.aspx.cs" Inherits="OpenEnvironment.WQXProjectEdit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ObjectDataSource ID="dsRefData" runat="server" SelectMethod="GetT_WQX_REF_DATA" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref">
        <SelectParameters>
            <asp:Parameter DefaultValue="SamplingDesignType" Name="tABLE" Type="String" />
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
            <asp:Parameter DefaultValue="true" Name="UsedInd" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>
     <div class="contentArea">
    <h2>
        Edit Project
    </h2>
    <p>
        <asp:Label ID="lblMsg" runat="server" CssClass="failureNotification"></asp:Label>
        <asp:Label ID="lblProjectIDX" runat="server" Style="display:none"/>
    </p>

    <div class="panel panel-default" >
    <div class="panel-body" >

   
        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtProjID" runat="server" placeholder="Project ID" ToolTip="Project ID" MaxLength="35" Width="250px" CssClass="form-control"></asp:TextBox>
        </div></div>
        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtProjName" placeholder="Project Name" ToolTip="Project Name" Width="250px" MaxLength="120" runat="server" CssClass="form-control"></asp:TextBox>
        </div></div>
        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtProjDesc" runat="server" placeholder="Project Description" ToolTip="Project Description" MaxLength="4000" TextMode="MultiLine" Rows="3" Width="250px"  CssClass="form-control"></asp:TextBox>
        </div></div>
        <div class="form-group"><div class="input-group">
            <p>Sampling Design Type:</p>
            <asp:DropDownList ID="ddlSampDesignTypeCode" runat="server"  CssClass="form-control" Width="250px"></asp:DropDownList>
        </div></div>
        <div class="form-group"><div class="input-group">
            <span class="fldLbl">QAPP Approved?: </span>
            <asp:CheckBox ID="chkQAPPInd" runat="server"  CssClass="fldTxt" />
            <span class="fldLbl">Approval Agency: </span><br /><asp:TextBox ID="txtQAPPAgency" runat="server" Width="250px" MaxLength="200" CssClass="form-control"></asp:TextBox>
        </div></div>
        <div class="form-group"><div class="input-group">
            <span class="fldLbl">Active?</span>
            <asp:CheckBox ID="chkActInd" runat="server" CssClass="fldTxt" />
        </div></div>
        <div class="form-group"><div class="input-group">
            <span class="fldLbl">Send to EPA</span>
            <asp:CheckBox ID="chkWQXInd" runat="server" CssClass="fldTxt" />
        </div></div>

        <br />
        <div class="btnRibbon">
            <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="Save &amp; Exit" 
                onclick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" Text="Cancel" 
                onclick="btnCancel_Click" />
        </div>
    
    </div></div>

    </div>

</asp:Content>
