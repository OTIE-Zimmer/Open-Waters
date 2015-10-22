<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="AnalyzeAdmin.aspx.cs" Inherits="OpenEnvironment.App_Pages.Secure.AnalyzeAdmin" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function GetConfirmation() {
            var reply = confirm("WARNING: This will delete the Analyze Configuration - are you sure you want to continue?");
            if (reply) {
                return true;
            }
            else {
                return false;
            }
        }
    </script>

       <script>

           var boolBC = false;

           function AddData() {

               $('#datUploadResults').show();
              
           }

           function RemoveData() {
           
               $('#datUploadResults').hide();
               boolBC = false;


           }



           function EditAnalyzeData() {
               $("#lblTitle").text("Edit an Analyze Configuration");
               $('#myEditTemplate').modal();
           }


           function block_toggle() {

               if (boolBC == false) {

                   $('#closeBlkCnt').hide();

                   boolBC = true;

               }
               else {
                   $('#closeBlkCnt').show();

                   boolBC = false;

               }
           }

  </script>



    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <asp:Timer ID="Timer1" runat="server" Interval="20000" ontick="Timer1_Tick"></asp:Timer>
    <ajaxToolkit:ModalPopupExtender ID="MPE1" runat="server" TargetControlID="btnConfig"
        PopupControlID="pnlModal" CancelControlID="btnClose" BackgroundCssClass="modalBackground" PopupDragHandleControlID="pnlModTtl">
    </ajaxToolkit:ModalPopupExtender>
    <asp:ObjectDataSource ID="dsAnalyzeConfig" runat="server" SelectMethod="GetT_OE_AnalyzeConfig" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Config">
        <selectparameters>
            <asp:SessionParameter DefaultValue="" Name="OrgID" SessionField="OrgID" Type="String" />
            <asp:SessionParameter DefaultValue="" Name="UserID" SessionField="UserIDX" Type="Int32" />
        </selectparameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="dsRefData" runat="server" SelectMethod="GetT_WQX_REF_DATA" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Ref">
        <SelectParameters>
            <asp:Parameter DefaultValue="SamplingDesignType" Name="tABLE" Type="String" />
            <asp:Parameter DefaultValue="true" Name="ActInd" Type="Boolean" />
            <asp:Parameter DefaultValue="true" Name="UsedInd" Type="Boolean" />
        </SelectParameters>
    </asp:ObjectDataSource>

 

        <%--Add Results--%>

     <div class="contentArea">
 

<%--Grid--%>

     

     
         <div class="row">
            <div class="col-xs-12">
                <div class="block">                          
                    <div class="block-head">
                        <h2>Edit Analyze Configuration - <%=Session["OrgID"] %></h2>
                        <ul class="buttons">
                            <%-- <li><a href="#" class="block-refresh"><span class="fa fa-refresh"></span></a></li>
                            <li><a href="#" class="block-toggle"><span class="fa fa-chevron-down"></span></a></li>
                            <li><a href="#" class="block-remove"><span class="fa fa-times"></span></a></li>--%>
                        </ul>  
                    </div>

        <div class="block-content">

  
        
         <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary" Text="Add an Analyze Configuration" onclick="btnAdd_Click" />
        
        <asp:ImageButton ID="btnConfig" runat="server" Height="24px"  style="float:right; padding-right:5px; padding-left:5px" ImageUrl="~/App_Images/ico_config.png" />
      
       
           <asp:Label ID="lblMsg" runat="server" CssClass="failureNotification"></asp:Label>

           <div class="table-responsive">
             <asp:GridView ID="grdAnalyzeConfig" 
                runat="server" 
                GridLines="None" 
                PagerStyle-CssClass="pgr"
                CssClass="table table-striped table-bordered"
                PageSize="6"
                AllowPaging="True"
                AutoGenerateColumns="False" 
                AlternatingRowStyle-CssClass="alt" 
                onrowcommand="grdAnalyzeConfig_RowCommand" 
                onrowcancelingedit="grdAnalyzeConfig_RowCancelingEdit" 
                onrowediting="grdAnalyzeConfig_RowEditing" onrowupdating="grdAnalyzeConfig_RowUpdating" OnPageIndexChanging="GridView1_PageIndexChanging"  >
                <Columns>
                    <asp:TemplateField HeaderText="Delete">
                        <ItemStyle HorizontalAlign="Center" Width="60px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edits"  data-toggle="modal" 
                                CommandArgument='<% #Eval("ANALYZECONFIG_IDX") %>' ImageUrl="~/App_Images/ico_edit.png"
                                ToolTip="Edit" />
                            <asp:ImageButton ID="DelButton" runat="server" CausesValidation="False" CommandName="Deletes" OnClientClick="return GetConfirmation();" 
                                CommandArgument='<% #Eval("ANALYZECONFIG_IDX") %>' ImageUrl="~/App_Images/ico_del.png"
                                ToolTip="Delete" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ANALYZECONFIG_NAME" HeaderText="Name" SortExpression="ANALYZECONFIG_NAME" />
                    <asp:BoundField DataField="SITES" HeaderText="Sites" SortExpression="SITES" />
                    <asp:BoundField DataField="CHARACTERISTIC" HeaderText="Characteristic" SortExpression="CHARACTERISTIC" />
                    <asp:BoundField DataField="START_DATE" HeaderText="Start Date" SortExpression="START_DATE" />
                    <asp:BoundField DataField="UPPER_THRESHOLD" HeaderText="Upper Threshold" SortExpression="UPPER_THRESHOLD" />
                    <asp:BoundField DataField="LOWER_THRESHOLD" HeaderText="Lower Threshold" SortExpression="LOWER_THRESHOLD" />
                </Columns>
            </asp:GridView>
           </div>
         </div>
        </div>
        </div>
        </div>
        <br />
       </div>
<!-- Modal -->
  <div class="modal fade" id="myEditTemplate" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 id="lblTitle" class="modal-title">Edit Analyze Config</h4>
                    </div>
                    <div class="modal-body">

    <p>
        <asp:Label ID="Label1" runat="server" CssClass="failureNotification"></asp:Label>
        <asp:Label ID="lblAnalyzeCongifIDX" runat="server" Style="display:none"/>
    </p>
   
         <div class="form-group">
            <label>Analyze Config Name:</label>
            <asp:TextBox ID="txtAnalyzeConfigName"  MaxLength="50" runat="server"  placeholder="Analyze Config Name" title="Analyze Config Name" CssClass="form-control"/>
        </div>
        <div class="form-group">
            <label>Sites:</label>
            <asp:TextBox ID="txtSites" runat="server" MaxLength="50" CssClass="form-control"/>
        </div>
         <div class="form-group">
            <label>Characteristic</label>
            <asp:TextBox ID="txtCharacteristic" runat="server" MaxLength="100" CssClass="form-control"/>
        </div>
         <div class="form-group">
            <label>Start Date</label>
            <asp:TextBox ID="txtStartDate" runat="server" MaxLength="50" CssClass="form-control"/>
        </div>
         <div class="form-group">
            <label>End Date</label>
            <asp:TextBox ID="txtEndDate" runat="server" MaxLength="50" CssClass="form-control"/>
        </div>
         <div class="form-group">
            <label>Upper Threshold</label>
            <asp:TextBox ID="txtUpperThreshold" runat="server" MaxLength="50" CssClass="form-control"/>
        </div>
         <div class="form-group">
            <label>Lower Threshold</label>
            <asp:TextBox ID="txtLowerThreshold" runat="server" MaxLength="50" CssClass="form-control"/>
        </div>
      </div>

      <div class="modal-footer">
           <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary" Text="Save &amp; Exit" 
                onclick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" data-dismiss="modal" CssClass="btn btn-primary" Text="Cancel" 
                onclick="btnCancel_Click" />   
      </div>
    </div>
  </div>
</div>
</asp:Content>