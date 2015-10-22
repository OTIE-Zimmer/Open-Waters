<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXOrgSettings.aspx.cs" Inherits="OpenEnvironment.WQXOrgSettings" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="../../Scripts/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/chosen.jquery.js" type="text/javascript"></script>
    <link href="../../Scripts/chosen.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function GetConfirmation() {
            var reply = confirm("WARNING: This will remove the characteristic from this organization - are you sure you want to continue?");
            if (reply) {
                return true;
            }
            else {
                return false;
            }
        }
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />
    <asp:ObjectDataSource ID="dsChar" runat="server" SelectMethod="GetT_WQX_REF_CHARACTERISTIC" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
            <asp:Parameter DefaultValue="false" Name="onlyUsedInd" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsTimeZone" runat="server" SelectMethod="GetT_WQX_REF_DEFAULT_TIME_ZONE" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref">
        <SelectParameters>
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsTaxa" runat="server" SelectMethod="GetT_WQX_REF_DATA" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref">
        <SelectParameters>
            <asp:Parameter DefaultValue="Taxon" Name="tABLE" Type="String" />
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
            <asp:Parameter DefaultValue="true" Name="UsedInd" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsAnalMethod" runat="server" SelectMethod="GetT_WQX_REF_ANAL_METHOD"  TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref" >
        <selectparameters>
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
        </selectparameters>
    </asp:ObjectDataSource>

    <div class="contentArea">

    <h2>
        Edit Organization Settings
    </h2>
    <p>
        <asp:Label ID="lblMsg" runat="server" CssClass="failureNotification"></asp:Label>
        <div class="fldPass">Before entering activities please setup some default settings for your organization. This includes the default timezone (used to determine the correct timezone for activities), 
            and a list of the characteristics and taxa that your organization samples for (used to populate the characteristic drop-down on the Activity Edit page).
        </div>
    </p>

    <div class="panel panel-default" >
    <div class="panel-body" >


    <div class="form-group"><div class="input-group">
        <asp:TextBox ID="txtOrgID" placeholder="Organization ID" ToolTip="Organization ID" runat="server" MaxLength="30" Width="250px" CssClass="form-control"></asp:TextBox>
    </div></div>
    <div class="form-group"><div class="input-group">
        <p>Default Time Zone:</p>
        <asp:DropDownList ID="ddlTimeZone" placeholder="Default Time Zone" ToolTip="Default Time Zone" runat="server" Width="258px" CssClass="form-control"></asp:DropDownList>
    </div></div>
    <div class="form-group"><div class="input-group">
        <asp:RadioButtonList ID="rbType" runat="server" AutoPostBack="true" CssClass="fldPass" OnSelectedIndexChanged="rbType_SelectedIndexChanged" RepeatDirection="Horizontal"
            style="  border-radius: 5px; padding: 10px; background-color: lightgray; font-size: 16px; margin-top: 20px;" >
            <asp:ListItem Text="Edit Characteristics List" Value="C"></asp:ListItem>
            <asp:ListItem Text="Edit Taxa List" Value="T"></asp:ListItem>
        </asp:RadioButtonList>
    </div></div>

    <div class="form-group"><div class="input-group">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <script>
                jQuery(document).ready(function () {
                    jQuery(".chosen").data("placeholder", "Being typing or select from list...").chosen({ allow_single_deselect: true });
                });
            </script>

            <table width="100%">
                <tr style="vertical-align:top;">
                    <td style="width:50%">
                        <asp:Panel ID="pnlChars" runat="server" CssClass="row" Visible="false">
                            <h2>Characteristics Used</h2>
                            <asp:DropDownList ID="ddlChar" runat="server" CssClass="chosen"></asp:DropDownList><br /><br />

                            <asp:Button ID="btnAddChar" runat="server" CssClass="btn btn-primary" Text="Add Characteristic" onclick="btnAddChar_Click"/>

                            <div class="table-responsive">
                            <asp:GridView ID="grdChar" runat="server" CssClass="table table-striped table-bordered" PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt" AllowPaging="False"
                                AutoGenerateColumns="False" DataKeyNames="CHAR_NAME" onrowcommand="grdChar_RowCommand" >
                                <Columns>
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                                        <ItemTemplate>
                                        <asp:ImageButton ID="ImaSelectButton" runat="server" CausesValidation="False" CommandName="Select" 
                                            CommandArgument='<% #Eval("CHAR_NAME") %>' ImageUrl="~/App_Images/selectbutton.png" ToolTip="Select" />
                                            <asp:ImageButton ID="DelButton" runat="server" CausesValidation="False" CommandName="Deletes"
                                                CommandArgument='<%# Eval("CHAR_NAME") %>' ImageUrl="~/App_Images/ico_del.png" ToolTip="Delete" OnClientClick="return GetConfirmation();" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="CHAR_NAME" HeaderText="Characteristic" SortExpression="CHAR_NAME" ControlStyle-Width="98%" />
                                    <asp:BoundField DataField="DEFAULT_UNIT" HeaderText="Unit" SortExpression="DEFAULT_UNIT" ControlStyle-Width="98%" />
                                    <asp:BoundField DataField="DEFAULT_DETECT_LIMIT" HeaderText="Detect Limit" SortExpression="DEFAULT_DETECT_LIMIT" ControlStyle-Width="98%" />
                                    <asp:BoundField DataField="T_WQX_REF_ANAL_METHOD.ANALYTIC_METHOD_ID" HeaderText="Analysis Method"  ControlStyle-Width="98%" />
                                    <asp:BoundField DataField="DEFAULT_SAMP_FRACTION" HeaderText="Sample Fraction" SortExpression="DEFAULT_SAMP_FRACTION" ControlStyle-Width="98%" />
                                    <asp:BoundField DataField="DEFAULT_RESULT_STATUS" HeaderText="Status" SortExpression="DEFAULT_RESULT_STATUS" ControlStyle-Width="98%" />
                                    <asp:BoundField DataField="DEFAULT_RESULT_VALUE_TYPE" HeaderText="Value Type" SortExpression="DEFAULT_RESULT_VALUE_TYPE" ControlStyle-Width="98%" />
                                    <asp:BoundField DataField="CREATE_DT" HeaderText="Create Date" SortExpression="CREATE_DT" DataFormatString = "{0:d}"  />
                                    <asp:BoundField DataField="CREATE_USERID" HeaderText="Created By" SortExpression="CREATE_USERID" />
                                </Columns>
                            </asp:GridView>
                            </fiv>

                        </asp:Panel>
                        <asp:Panel ID="pnlTaxa" runat="server" CssClass="row"  Visible="false">

                            <h2>Taxa Used</h2>

                            <asp:DropDownList ID="ddlTaxa" runat="server" CssClass="chosen"></asp:DropDownList>
                            <asp:Button ID="btnAddTaxa" runat="server" CssClass="btn btn-primary" Text="Add Taxa" onclick="btnAddTaxa_Click"/><br /><br />
                            <div class="table-responsive">
                            <asp:GridView ID="grdTaxa" runat="server" CssClass="table table-striped table-bordered" AlternatingRowStyle-CssClass="alt" AllowPaging="False" AutoGenerateColumns="False" 
                                DataKeyNames="BIO_SUBJECT_TAXONOMY" OnRowCommand="grdTaxa_RowCommand" >
                                <Columns>
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemStyle HorizontalAlign="Center" Width="60px" />
                                        <ItemTemplate>
                                            <asp:ImageButton ID="DelButton" runat="server" CausesValidation="False" CommandName="Deletes"
                                                CommandArgument='<%# Eval("BIO_SUBJECT_TAXONOMY") %>' ImageUrl="~/App_Images/ico_del.png" ToolTip="Delete" OnClientClick="return GetConfirmation();" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="BIO_SUBJECT_TAXONOMY" HeaderText="Taxa Name" SortExpression="BIO_SUBJECT_TAXONOMY" ControlStyle-Width="98%" />
                                    <asp:BoundField DataField="CREATE_DT" HeaderText="Added Date" SortExpression="CREATE_DT" />
                                    <asp:BoundField DataField="CREATE_USERID" HeaderText="Added By" SortExpression="CREATE_USERID" />
                                </Columns>
                            </asp:GridView>
                            </div>

                        </asp:Panel>

                    </td>
                    <td style="width:50%">
                        <br /><br />
                        <asp:Panel ID="pnlSelChar" runat="server" Visible="false" style="padding-top: 80px">
                            <h2>Characteristic Default Values</h2>
                            <div class="form-group"><div class="input-group"> 
                                <asp:TextBox ID="txtSelChar" runat="server" placeholder="Characteristic" ToolTip="Characteristic" CssClass="form-control" Enabled="false" Width="220px"></asp:TextBox>
                            </div></div>
                            <div class="form-group"><div class="input-group">
                                <asp:DropDownList ID="ddlUnit" placeholder="Default Unit" ToolTip="Default Unit" runat="server" CssClass="form-control"  Width="220px"></asp:DropDownList>
                            </div></div>
                            <div class="form-group"><div class="input-group">
                                <asp:TextBox ID="txtDetectLimit" runat="server" placeholder="Detection Limit" ToolTip="Detection Limit" CssClass="form-control"  Width="220px" MaxLength="12" ></asp:TextBox>
                            </div></div>
                            <div class="form-group"><div class="input-group">
                                <p>Analysis Method:</p>
                                <asp:DropDownList ID="ddlAnalMethod" runat="server" CssClass="form-control"  Width="220px"></asp:DropDownList>
                            </div></div>
                           <div class="form-group"><div class="input-group">
                                <p>Sample Fraction</p>
                                <asp:DropDownList ID="ddlFraction" runat="server" CssClass="form-control"  Width="220px"></asp:DropDownList>
                            </div></div>
                           <div class="form-group"><div class="input-group">
                                <p>Result Status</p>
                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control"  Width="220px"></asp:DropDownList>
                            </div></div>
                            <div class="form-group"><div class="input-group">
                                <p>Result Value Type</p>
                                <asp:DropDownList ID="ddlValueType" runat="server" CssClass="form-control" Width="220px" ></asp:DropDownList>
                            </div></div>
                           <div class="form-group"><div class="input-group">
                                <asp:Label ID="lblMsgDtl" runat="server" CssClass="failureNotification"></asp:Label>
                            </div></div>
                            <div class="btnRibbon">
                                <asp:Button ID="btnSaveDtl" runat="server" CssClass="btn" OnClick="btnSaveDtl_Click" Text="Save" />
                            </div>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </ContentTemplate></asp:UpdatePanel>
    </div></div>

    <div class="btnRibbon">
        <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="Save" onclick="btnSave_Click" />
        <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" Text="Exit" onclick="btnCancel_Click" />
    </div>

    </div>
    
    </div></div>

</asp:Content>
