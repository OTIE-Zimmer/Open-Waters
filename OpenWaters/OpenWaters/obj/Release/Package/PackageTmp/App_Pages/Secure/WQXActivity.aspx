﻿<%@ Page Title="TFerst Mvskogee Open Waters - Activities" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="WQXActivity.aspx.cs" Inherits="OpenEnvironment.WQXActivity" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxtoolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function GetConfirmation() {
            var reply = confirm("WARNING: This will delete the activity - are you sure you want to continue?");
            if (reply) {
                return true;
            }
            else {
                return false;
            }
        }
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:Timer ID="Timer1" runat="server" Interval="20000" ontick="Timer1_Tick" ></asp:Timer>
    <ajaxToolkit:ModalPopupExtender ID="MPE1" runat="server" TargetControlID="btnConfig"
        PopupControlID="pnlModal" CancelControlID="btnClose" BackgroundCssClass="modalBackground" PopupDragHandleControlID="pnlModTtl">
    </ajaxToolkit:ModalPopupExtender>
    <asp:ObjectDataSource ID="dsMonLoc" runat="server" SelectMethod="GetWQX_MONLOC_ByOrgID" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_WQX" >
        <selectparameters>
            <asp:SessionParameter DefaultValue="" Name="OrgID" SessionField="OrgID" Type="String" />
        </selectparameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsActType" runat="server" SelectMethod="GetT_WQX_REF_DATA_ActivityTypeUsed" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="OrgID" SessionField="OrgID" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="dsProject" runat="server" SelectMethod="GetWQX_PROJECT" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_WQX">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
            <asp:SessionParameter DefaultValue="" Name="OrgID" SessionField="OrgID" Type="String" />
            <asp:Parameter DefaultValue="false" Name="WQXPending" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <div class="contentArea" >

    <h2>
        Activities (Samples)
    </h2>

    <div class="panel panel-default">
    <div class="panel-body">

    <div class="table-responsive">


    <asp:Panel ID="pnlFilter" CssClass="fltBox" runat="server" DefaultButton="btnFilter">
        <div class="fltTitle">Data Filters</div>
        <div class="fltMain">
            <div class="form-group"><div class="input-group">
                <div style="width:360px; float:left"> 
                    <asp:DropDownList CssClass="form-control" placeholder="Monitoring Location" ToolTip="Monitoring Location" ID="ddlMonLoc" runat="server" Width="196px"></asp:DropDownList>
                </div>
                <div style="float:left"> 
                    <p>Activity Type:</p>
                    <asp:DropDownList CssClass="form-control" ID="ddlActType" runat="server" Width="250px" ></asp:DropDownList>
                </div>
                <div style="float:right"> 
                    <asp:CheckBox ID="chkDeletedInd" runat="server" Checked="false" Text="Display Deleted Activities" />
                </div>
            </div></div>

            <div class="form-group"><div class="input-group">
                <div style="width:360px; float:left"> 
                    <p>Date Range</p>
                    <asp:TextBox ID="txtStartDt" placeholder="Start Date" ToolTip="Start Date" runat="server" Width="105px" CssClass="form-control"></asp:TextBox>
                    <ajaxToolkit:MaskedEditExtender ID="txtStartDt_MaskedEditExtender" runat="server"
                        Enabled="True" TargetControlID="txtStartDt" MaskType="Date" UserDateFormat="MonthDayYear"
                        Mask="99/99/9999">
                    </ajaxToolkit:MaskedEditExtender>
                    <ajaxToolkit:CalendarExtender ID="txtStartDt_CalendarExtender" runat="server" Enabled="True"
                        TargetControlID="txtStartDt">
                    </ajaxToolkit:CalendarExtender>
                   
                    <asp:TextBox ID="txtEndDt" placeholder="End Date" ToolTip="End Date" runat="server" Width="105px"  CssClass="form-control" ></asp:TextBox>
                    &nbsp;&nbsp;
                    <ajaxToolkit:MaskedEditExtender ID="txtEndDt_MaskedEditExtender" runat="server"
                        Enabled="True" TargetControlID="txtEndDt" MaskType="Date" UserDateFormat="MonthDayYear" Mask="99/99/9999">
                    </ajaxToolkit:MaskedEditExtender>
                    <ajaxToolkit:CalendarExtender ID="txtEndDt_CalExtender" runat="server" Enabled="True"
                        TargetControlID="txtEndDt">
                    </ajaxToolkit:CalendarExtender>
                </div>  
                
                              
                <div style="float:left"> 
                    <p>Project</p>
                    <asp:DropDownList CssClass="form-control" ID="ddlProject" runat="server" Width="250px"></asp:DropDownList>
                </div>
            </div></div>


            <div class="form-group"><div class="input-group">
                <asp:Button ID="btnFilter" runat="server" CssClass="btn btn-primary" Text="Apply" onclick="btnFilter_Click" />
            </div></div>
        </div>
        <br />
    </asp:Panel>
    <asp:UpdatePanel runat="server" ID="TimedPanel" UpdateMode="Conditional">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
        </Triggers>
        <ContentTemplate>
            <asp:Label ID="lblMsg" runat="server" CssClass="failureNotification" ></asp:Label>
            <div class="table-responsive">
            <asp:GridView ID="grdActivity" runat="server" 
                GridLines="None"  CssClass="table table-striped table-bordered" PagerStyle-CssClass="pgr" AutoGenerateColumns="False" PageSize="<%# PAGE_SIZE %>" 
                AlternatingRowStyle-CssClass="alt" onrowcommand="grdActivity_RowCommand" AllowPaging="true" OnPageIndexChanging="grdActivity_PageIndexChanging" >
                <Columns>
                    <asp:TemplateField HeaderText="Edit">
                        <ItemStyle HorizontalAlign="Center" Width="60px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edits" AlternateText="Edit"
                                CommandArgument='<% #Eval("ACTIVITY_IDX") %>' ImageUrl="~/App_Images/ico_edit.png" ToolTip="Edit" />
                            <asp:ImageButton ID="DelButton" runat="server" CausesValidation="False" CommandName="Deletes" OnClientClick="return GetConfirmation();"
                                CommandArgument='<% #Eval("ACTIVITY_IDX") %>' ImageUrl="~/App_Images/ico_del.png" ToolTip="Delete" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ACTIVITY_ID" HeaderText="Activity ID" SortExpression="ACTIVITY_ID" />
                    <asp:BoundField DataField="MONLOC_ID" HeaderText="Monitoring Loc." SortExpression="MONLOC_ID" />
                    <asp:BoundField DataField="PROJECT_ID" HeaderText="Project" SortExpression="PROJECT_ID" />
                    <asp:BoundField DataField="ACT_TYPE" HeaderText="Type" SortExpression="ACT_TYPE" />
                    <asp:BoundField DataField="ACT_MEDIA" HeaderText="Media" SortExpression="ACT_MEDIA" />
                    <asp:BoundField DataField="ACT_SUBMEDIA" HeaderText="SubMedia" SortExpression="ACT_SUBMEDIA" />
                    <asp:BoundField DataField="ACT_START_DT" HeaderText="Sample Date" SortExpression="ACT_START_DT" />
                    <asp:BoundField DataField="ACT_END_DT" HeaderText="End Date" SortExpression="ACT_END_DT" />
                    <asp:BoundField DataField="SAMP_COLL_METHOD" HeaderText="Sample Collection Method" SortExpression="SAMP_COLL_METHOD" />
                    <asp:BoundField DataField="SAMP_COLL_EQUIP" HeaderText="Collection Equipment" SortExpression="SAMP_COLL_EQUIP" />
                    <asp:BoundField DataField="SAMP_COLL_EQUIP_COMMENT" HeaderText="Equipment Comment" SortExpression="SAMP_COLL_EQUIP_COMMENT" />
                    <asp:BoundField DataField="SAMP_PREP_METHOD" HeaderText="Sample Prep Method" SortExpression="SAMP_PREP_METHOD" />
                    <asp:BoundField DataField="ACT_DEPTHHEIGHT_MSR" HeaderText="Depth" SortExpression="ACT_DEPTHHEIGHT_MSR" />
                    <asp:BoundField DataField="TOP_DEPTHHEIGHT_MSR" HeaderText="Top Depth" SortExpression="TOP_DEPTHHEIGHT_MSR" />
                    <asp:BoundField DataField="BOT_DEPTHHEIGHT_MSR" HeaderText="Bottom Depth" SortExpression="BOT_DEPTHHEIGHT_MSR" />
                    <asp:BoundField DataField="DEPTH_REF_POINT" HeaderText="Depth Reference Point" SortExpression="DEPTH_REF_POINT" />
                    <asp:BoundField DataField="ACT_COMMENT" HeaderText="Comment" SortExpression="ACT_COMMENT" />
                    <asp:TemplateField HeaderText="Send to EPA"> 
                        <ItemStyle HorizontalAlign="Center" />                        
                        <ItemTemplate> 
                            <asp:CheckBox ID="chkWQX" Enabled="false" runat="server" Checked='<%# (Eval("WQX_IND") == null ? false : Eval("WQX_IND")) %>' />
                            <asp:ImageButton ID="WQXButton" runat="server" CausesValidation="False" CommandName="WQX"
                                CommandArgument='<% #Eval("ACTIVITY_IDX") %>' ImageURL='<%# GetImage((string)Eval("WQX_SUBMIT_STATUS"),(Boolean)(Eval("WQX_IND")==null ? false : Eval("WQX_IND")) ) %>' ToolTip="WQX History" />
                        </ItemTemplate> 
                    </asp:TemplateField> 
                </Columns>
            </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="btnRibbon">
        <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary" Text="Add New" onclick="btnAdd_Click" ToolTip="Add a New Activity" />
        <asp:ImageButton ID="btnExcel" runat="server" Height="24px" style="float:right; " ImageUrl="~/App_Images/ico_xls.png" onclick="btnExcel_Click" ToolTip="Export to Excel" />
        <asp:ImageButton ID="btnConfig" runat="server" Height="24px"  style="float:right; padding-right:5px; padding-left:5px" ImageUrl="~/App_Images/ico_config.png" ToolTip="Show Additional Columns"/>
    </div>


    <br />

    <!-- ******************** MODAL PANEL -->
    <asp:Panel ID="pnlModal" Width="500px" runat="server" CssClass="modalWindow" Style="display: none;">
        <div style="padding: 6px; background-color: #FFF; border: 1px solid #98B9DB;">
            <asp:Panel ID="pnlModTtl" runat="server" CssClass="modalTitle" Style="cursor: move">
                Select Fields to Include in View
            </asp:Panel>
            <div class="row" style="height:100px;">
                <div class="fldLbl">
                    <asp:CheckBoxList ID="chkFields" Width="500px" runat="server" RepeatColumns="2">
                        <asp:ListItem Text="SAMP_ACT_END_DT"></asp:ListItem>
                        <asp:ListItem Text="SAMP_COLL_METHOD"></asp:ListItem>
                        <asp:ListItem Text="SAMP_COLL_EQUIP"></asp:ListItem>
                        <asp:ListItem Text="SAMP_PREP"></asp:ListItem>
                        <asp:ListItem Text="SAMP_DEPTH"></asp:ListItem>
                    </asp:CheckBoxList>
                </div>
            </div>
            <div class="btnRibbon">
                <asp:Button ID="btnConfigSave" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnConfigSave_Click" />
                <asp:Button ID="btnClose" runat="server" Text="Cancel" CssClass="btn btn-primary" />
            </div>
        </div>
    </asp:Panel>




    </div>
    </div>
    </div>
    </div>

</asp:Content>
