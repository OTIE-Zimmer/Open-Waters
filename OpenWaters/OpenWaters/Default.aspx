<%@ Page Title="Home Page" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="OpenEnvironment._Default" %>
<!DOCTYPE html>
<html  >
<head runat="server">
   <!-- Use Unicode character encoding -->
  <meta charset="utf-8"/>
  <!-- Tell IE to display content in highest HTML 5 mode available -->
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <!-- Tell mobile browsers to use the device width when rendering -->
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Tribal-FERST Mvskoke Open Waters Module - Environmental Data Management</title>

   <link href="css/styles2.css" rel="stylesheet" />

    <style>
    body { 
     background: url('App_Images/green2.jpg') no-repeat center center fixed; 
     -webkit-background-size: cover;
     -moz-background-size: cover;
     -o-background-size: cover;
     background-size: cover;
    }

    </style>

</head>

    
<body>

<div id="wrapperHeader"/>



 <form  id="MainForm" runat="server" >
 

          <div class="block-login" >
                                     
          <div class="block-login-content">

          <h2><span style="color: #fff; font-weight: bold;"><i>Log into Tribal-FERST Mvskoke Open Waters Module</i></span></h2>
      
          <div class="form-group">
            <asp:ValidationSummary ID="valSummary" 
                                   runat="server"
                                   CssClass="text-danger valSummary"  />
          </div>
        <div >
             <asp:Label ID="lblTestWarn" runat="server" CssClass="fldErrLg" Text="" Visible="false" Style="margin-top:20px"></asp:Label>
            <asp:Login ID="LoginUser" runat="server" EnableViewState="false" RenderOuterTable="true" OnLoggedIn="LoginUser_LoggedIn" OnLoginError="LoginUser_LoginError">
                <LayoutTemplate>
                    <span class="failureNotification">
                        <asp:Literal ID="FailureText" runat="server"></asp:Literal>
                    </span>
                    <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="failureNotification" ValidationGroup="LoginUserValidationGroup" />
                   

                    <div class="form-group">
                    <div class="input-group">
                        <label class="sr-only" for="txtLoginEmail">Username</label>
                        
                        <asp:TextBox ID="UserName"
                             CssClass="form-control"
                             autofocus="autofocus"
                             required="required"
                             placeholder="Username"
                             title="Username"
                             runat="server" >
                        </asp:TextBox>

                    <span class="input-group-addon">
                    <i class="glyphicon glyphicon-user"></i>
                    </span>
                    </div>
                    </div>
                       
                     <div class="form-group">
                     <div class="input-group">
                      <label class="sr-only" for="txtLoginPassword">Password</label>
                        
                        <asp:TextBox 
                            ID="Password" 
                            runat="server" 
                            CssClass="form-control" 
                            TextMode="Password"
                            required="required"
                            placeholder="Password"
                            title="Password"   
                            >
                        </asp:TextBox>
                     <span class="input-group-addon">
                     <i class="glyphicon glyphicon-lock"></i>
                     </span>
                    </div>
                  </div>

                       
                    <div class="form-group">
                    <a href="~/Account/ResetPassword.aspx" class="pull-right">Forgot password?</a>
                    </div>

             <div class="form-group">
            <div >
              <div class="checkbox">
                <label>
                  <asp:CheckBox ID="chkRememberMe" runat="server" Checked="true" />
                  Stay logged in
                </label>
              </div>
            </div>
          </div>
          <div class="row">
            <div >
              <div id="divMessageArea" 
                   runat="server" 
                   visible="false">
                <div class="well">
                  <asp:Label ID="lblMessage" runat="server"
                    CssClass="text-warning"
                    Text="Area to display messages." />
                </div>
              </div>
            </div>
          </div>
        </div>

       
          <asp:Button CssClass="btn btn-primary" ID="LoginButton" width="100%"  runat="server" CommandName="Login" Text="Log In" ValidationGroup="LoginUserValidationGroup" />
       

 <div class="footer"> 
        Version: <asp:Label ID="lblVer" runat="server"></asp:Label> | 
        <asp:HyperLink runat="server" NavigateUrl="~/App_Pages/Public/License.aspx" Text="License"></asp:HyperLink> 
    </div>

        </LayoutTemplate>

                
            </asp:Login>

           
</div>
</div>
</div>
       
   
  


</form>
</body>
</html>
