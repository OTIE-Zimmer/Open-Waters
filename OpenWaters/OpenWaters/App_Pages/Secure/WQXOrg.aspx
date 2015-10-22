<%@ Page Title="TFerst Mvskogee Open Waters - Organizations" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXOrg.aspx.cs" Inherits="OpenEnvironment.WQXOrg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:ObjectDataSource ID="dsOrg" runat="server" SelectMethod="GetWQX_ORGANIZATION" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_WQX">
    </asp:ObjectDataSource>
    <div class="contentArea" >
    <h2>
        Organization Info
    </h2>

    <div class="panel panel-default">
    <div class="panel-body">

    <div class="table-responsive">
    <asp:GridView ID="grdOrg" runat="server" 
                GridLines="None" 
                PagerStyle-CssClass="pgr"
                CssClass="table table-striped table-bordered"
                PageSize="6"
                AllowPaging="True"
                AutoGenerateColumns="False" AlternatingRowStyle-CssClass="alt" 
                onrowcommand="grdOrg_RowCommand" >
        <Columns>
            <asp:TemplateField HeaderText="Edit">
                <ItemStyle HorizontalAlign="Center" Width="60px" />
                <ItemTemplate>
                    <asp:ImageButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edits"
                        CommandArgument='<% #Eval("ORG_ID") %>' ImageUrl="~/App_Images/ico_edit.png"
                        ToolTip="Edit" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="ORG_ID" HeaderText="ID" SortExpression="ORG_ID" />
            <asp:BoundField DataField="ORG_FORMAL_NAME" HeaderText="Name" SortExpression="ORG_FORMAL_NAME" />
            <asp:BoundField DataField="ORG_DESC" HeaderText="Description" SortExpression="ORG_DESC" />
            <asp:BoundField DataField="TRIBAL_CODE" HeaderText="Tribal Code" SortExpression="TRIBAL_CODE" />
            <asp:BoundField DataField="ELECTRONICADDRESS" HeaderText="Electronic Address" SortExpression="ELECTRONICADDRESS" />
            <asp:BoundField DataField="ELECTRONICADDRESSTYPE" HeaderText="Address Type" SortExpression="ELECTRONICADDRESSTYPE" />
            <asp:BoundField DataField="TELEPHONE_NUM" HeaderText="Phone" SortExpression="TELEPHONE_NUM" />
            <asp:BoundField DataField="TELEPHONE_EXT" HeaderText="Ext" SortExpression="TELEPHONE_EXT" />
            <asp:BoundField DataField="TELEPHONE_NUM_TYPE" HeaderText="Phone Type" SortExpression="TELEPHONE_NUM_TYPE" />
        </Columns>
    </asp:GridView>
    </div>
    <div class="btnRibbon">
        <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary" Text="Add New" onclick="btnAdd_Click" />
        <asp:ImageButton ID="btnExcel" runat="server"  style="float:right; padding-right:5px; padding-left:5px"  ImageUrl="~/App_Images/ico_xls.png" onclick="btnExcel_Click" ToolTip="Export to Excel" />
    </div>


    </div>

    </div>
    </div>

</asp:Content>
