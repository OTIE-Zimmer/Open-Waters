<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="OpenEnvironment.Help" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="contentArea" >
    
    <div style="padding: 0px 0px 0px 15px">
        <h2>Support Materials:</h2>
        <br />
        <div class="indent">
            <b>Administration and User's Guide:</b> 
            <div class="indent">
                <div class="smallnote">Document describes how to use TFerst Mvskogee Open Waters.</div> 
                <asp:HyperLink ID="hlUsersGuide" runat="server" NavigateUrl="~/App_Docs/UsersGuide.docx" Target="_blank">Link</asp:HyperLink>
            </div>
            <br /><br />
            
            <br /><br /><b>Sample Import Template (Excel):</b>
            <div class="indent">
                <div class="smallnote">This template is used when your characteristics are arranged in columns. This is typical of csv files that export directly off of multiprobes (YSI, Manta, etc).</div> 
                <asp:HyperLink ID="hlSampCT" runat="server" NavigateUrl="~/App_Docs/SampleFile.xls" Target="_blank">Link</asp:HyperLink>
            </div>

            <br /><br />
        </div>

        <h1>Email Support:</h1>
        <div class="indent">
            <div class="smallnote">Send email for additional support.</div> 
            <asp:HyperLink ID="hlEmail" runat="server" NavigateUrl = "mailto:abc@abc.com" Text = "abc@abc.com"></asp:HyperLink>
        </div><br /><br />
    </div>
    </div>
</asp:Content>
