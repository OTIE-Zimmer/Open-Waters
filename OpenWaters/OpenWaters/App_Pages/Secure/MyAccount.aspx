<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="MyAccount.aspx.cs" Inherits="OpenEnvironment.MyAccount" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="contentArea" >
    <div style="padding: 0px 0px 0px 15px">
        <h2>
            My Account
        </h2>
        <div class="divHelp">
            View and edit your account information.
        </div>
        <p>
            <asp:Label ID="lblMsg" runat="server" CssClass="failureNotification"></asp:Label>
        </p>

       <div class="panel panel-default">
       <div class="panel-body">


            <div class="form-group"><div class="input-group">
                <asp:TextBox ID="txtUserName" runat="server" placeholder="User Name" title="User Name" CssClass="form-control" ReadOnly="true"></asp:TextBox>
            </div></div>
            <div class="form-group"><div class="input-group">
                    <asp:TextBox ID="txtFName" placeholder="First Name" title="First Name" runat="server" CssClass="form-control" MaxLength="40"></asp:TextBox>
            </div></div>
            <div class="form-group"><div class="input-group">
                <asp:TextBox ID="txtLName" runat="server" placeholder="Last Name" title="Last Name" CssClass="form-control" MaxLength="40"></asp:TextBox>
            </div></div>
            <div class="form-group"><div class="input-group">
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Email" title="Email" CssClass="form-control" MaxLength="150"></asp:TextBox>
            </div></div>
            <div class="form-group"><div class="input-group">
                    <asp:TextBox ID="txtPhone" runat="server" placeholder="Phone" title="Phone" CssClass="form-control" MaxLength="12"></asp:TextBox>
            </div></div>
            <div class="form-group"><div class="input-group">
                <p>Roles:<p>
                <asp:ListBox ID="lbRoleList" Width="150px" CssClass="form-control" runat="server" ></asp:ListBox>
                <br />
            </div></div>
            <div class="form-group"><div class="input-group">
                <p>Organizations:</p>
                <asp:ListBox ID="lblOrgList" Width="150px" CssClass="form-control" runat="server" ></asp:ListBox>
                <br />
            </div></div>
            <br />
            <div class="btnRibbon">
                <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="btnSave_Click" />
                <asp:Button ID="btnResetPwd" runat="server" CssClass="btn btn-primary" Text="Change Password" OnClick="btnResetPwd_Click" />
            </div>
    </div>
    </div> 
    </div>
    </div>
</asp:Content>
