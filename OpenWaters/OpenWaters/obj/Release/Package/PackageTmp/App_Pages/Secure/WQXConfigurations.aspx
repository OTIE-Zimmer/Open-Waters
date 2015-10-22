<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXConfigurations.aspx.cs" Inherits="OpenEnvironment.App_Pages.Secure.WQXConfigurations" %>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="contentArea">
       <div class="row">

           <div class="col-xs-6">
                  Select Excel Sheet: 
                  <asp:DropDownList ID="sheetCombo" CssClass="form-control" runat="server" AutoPostBack="True" OnSelectedIndexChanged="sheetCombo_SelectedIndexChanged" />
                  Configuration Name: 
                <asp:TextBox ID="configurationName" CssClass="form-control" runat="server"/><br />
               
            </div>

        </div>

        <div class="row">
          
                Align your columns:<br />
                Columns in sheet: <br />

            <div class="col-xs-6">
              
                <asp:Panel ID="columnPanel" runat="server" CssClass="btnRibbon" /><br />
            
            </div>

        </div>


       <asp:Button ID="btnSaveConfig" Text="Submit" runat="server" OnClick="btnSaveConfig_Click" />

      
    <br/><br/><br/>
    <div class="table-responsive">         
        <asp:ObjectDataSource ID="dsColumn" runat="server" SelectMethod="GetT_OE_COLUMNCONFIG" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Config" />
        <asp:GridView ID="GridView1"  runat="server" CssClass="table table-striped table-bordered" />
    </div>
    </div>
</asp:Content>
