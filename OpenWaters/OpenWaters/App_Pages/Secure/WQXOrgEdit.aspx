<%@ Page Title="Tribal-FERST Mvskoke Open Waters Module - Organization Details" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXOrgEdit.aspx.cs" Inherits="OpenEnvironment.WQXOrgEdit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        jQuery(document).ready(function () {
            //radio button on doc ready
            var value2 = $("input:checked").val();//$('#ctl00_MainContent_rbCDX_0 input:checked').val();
            if (value2 == 1) {
                $("#divCDXme").show();
                $("#divCDXglobal").hide();
            }
            else {
                $("#divCDXme").hide();
                $("#divCDXglobal").show();
            }
            //click radio button
            $('input[name="ctl00$MainContent$rbCDX"]').change(function () {
                var value = $("input:checked").val();
                if (value == 1)
                {
                    $("#divCDXme").show();
                    $("#divCDXglobal").hide();
                }
                else
                {
                    $("#divCDXme").hide();
                    $("#divCDXglobal").show();
                }
            });
        });
    </script>

    <asp:ObjectDataSource ID="dsRefData" runat="server" SelectMethod="GetT_WQX_REF_DATA" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref">
        <SelectParameters>
            <asp:Parameter DefaultValue="Tribe" Name="tABLE" Type="String" />
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
            <asp:Parameter DefaultValue="true" Name="UsedInd" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <div class="contentArea" >
    <h1>
        Edit Organization
    </h1>
    <p>
        <asp:Label ID="lblMsg" runat="server" CssClass="failureNotification"></asp:Label>
    </p>


       <div class="panel panel-default" >
       <div class="panel-body">
    

        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtOrgID" runat="server" placeholder="Organization ID" ToolTip="Organization ID" MaxLength="30" Width="250px"  CssClass="form-control"></asp:TextBox>
        </div></div>
        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtOrgName" placeholder="Organization Name" ToolTip="Organization Name" Width="250px" MaxLength="120" runat="server"  CssClass="form-control"></asp:TextBox>
        </div></div>
        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtOrgDesc" placeholder="Description" ToolTip="Description" Width="250px" MaxLength="500" TextMode="MultiLine" Rows="2" runat="server"  CssClass="form-control"></asp:TextBox>
        </div></div>
            <p>Tribal Code:</p>
        <div class="form-group"><div class="input-group">
            
            <asp:DropDownList ID="ddlTribalCode" runat="server" placeholder="Tribal Code" ToolTip="Tribal Code" Width="258px"  CssClass="form-control"></asp:DropDownList>
        </div></div>
        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtOrgEmail" MaxLength="120" runat="server" placeholder="Email" ToolTip="Email" Width="250px"   CssClass="form-control"></asp:TextBox>
        </div></div>
        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtOrgPhone" MaxLength="15" runat="server" placeholder="Phone" ToolTip="Phone" Width="250px"   CssClass="form-control"></asp:TextBox>
        </div></div>
        <div class="form-group"><div class="input-group">
            <asp:TextBox ID="txtOrgPhoneExt" runat="server" placeholder="Phone Extension" ToolTip="Phone Extension" Width="250px" MaxLength="6"  CssClass="form-control"></asp:TextBox>
        </div></div>
        <asp:Panel ID="pnlCDX" runat="server" CssClass="" style="margin-top:20px; width: 600px; background:#dedede repeat-x top; border:1px solid #808080;" >
            <h3 style="margin-top:0px">Credentials for Submitting to EPA</h3>
            <div class="form-group"><div class="input-group">
                <asp:Label ID="lblCDXSubmitInd" runat="server"></asp:Label>
            </div></div>
            <asp:RadioButtonList ID="rbCDX" runat="server">
                <asp:ListItem Text="Submit to EPA using my own NAAS credentials" Value="1"></asp:ListItem>
                <asp:ListItem Text="Submit to EPA using Tribal-FERST Mvskoke Open Waters Module global NAAS credentials" Value="2"></asp:ListItem>
            </asp:RadioButtonList>
            <div id="divCDXme" style="display:none; padding: 0px 0px 0px 17px">
                <div class="form-group"><div class="input-group">
                    <asp:TextBox ID="txtCDX" runat="server" placeholder="CDX Submitter" ToolTip="CDX Submitter" Width="220px" MaxLength="100"  CssClass="form-control"></asp:TextBox>
                </div></div>
                <div class="form-group"><div class="input-group">
                    <asp:TextBox ID="txtCDXPwd" runat="server" placeholder="CDX Submitter Password" ToolTip="CDX Submitter Password" Width="220px" TextMode="Password" MaxLength="100"  CssClass="form-control"></asp:TextBox>
                </div></div>        
                <div class="form-group"><div class="input-group">
                    <asp:Button ID="btnTestNAASLocal" runat="server" Text="Test My Credentials" CssClass="btn btn-primary" OnClick="btnTestNAASLocal_Click" />
                </div></div>
                <br />
            </div>
            <div id="divCDXglobal"  style="display:none">
                <asp:Button ID="btnTestNAASGlobal" runat="server" Text="Check if Tribal-FERST Mvskoke Open Waters Module is Authorized to Submit for Your Organization"  CssClass="btn btn-primary" OnClick="btnTestNAASGlobal_Click" />
            </div>
            <br />

            <asp:Panel ID="pnlCDXResults" runat="server" style="padding-left: 24px;" Visible="false" >
                <h3 style="margin-bottom:5px">Test Results</h3>
                <b>Authentication:</b>
                <br />
                <span id="spnAuth" runat="server" class="" style="left:0px; top:0px; display: inline-block; position: relative; width: 20px; height: 20px; background-size: 100% auto;"></span>
                <asp:Label ID="lblAuthResult" runat="server" style="vertical-align: top;"></asp:Label>
                <br />
                <br />
                <b>Ability to Submit:</b>
                <br />
                <span id="spnSubmit" runat="server" class="" style="left:0px; top:0px; display: inline-block; position: relative; width: 20px; height: 20px; background-size: 100% auto;"></span>
                <asp:Label ID="lblSubmitResult" runat="server"  style="vertical-align: top;"></asp:Label>
            </asp:Panel>

        </asp:Panel>

        <asp:Panel ID="pnlRoles" runat="server" CssClass="row">
            <table>
                <tr>
                    <td>
                        Available Users<br />
                        <asp:ListBox ID="lbAllUsers" runat="server" Height="150px" Width="150px"  CssClass="form-control">
                        </asp:ListBox>
                    </td>
                    <td>
                        <asp:CheckBox ID="chkAdmin" CssClass="btn btn-primary" runat="server" Text="Add as Admin" />
                        <br /><br />
                        <asp:Button ID="btnAdd" CssClass="btn btn-primary" Width="180px" runat="server" Text="Add User to Org &gt;&gt;" OnClick="btnAdd_Click" /><br />
                        <asp:Button ID="btnRemove" CssClass="btn btn-primary" Width="180px" runat="server" Text="&lt;&lt; Remove User From Org" OnClick="btnRemove_Click" />
                    </td>
                    <td>
                        Users in Organization<br />
                        <asp:ListBox ID="lbUserInRole" runat="server" Height="150px" Width="150px"  CssClass="form-control">
                        </asp:ListBox>
                    </td>
                </tr>
            </table>
        </asp:Panel>
            <br />
        <div class="btnRibbon">
            <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="Save &amp; Exit" onclick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" Text="Cancel" onclick="btnCancel_Click" />
            <asp:Button ID="btnSettings" runat="server" CssClass="btn btn-primary" Text="Edit Default Data" OnClick="btnSettings_Click" />
        </div>

</div>
</div>

</div>
</asp:Content>
