<%@ Page Title="" Language="C#" MasterPageFile="SiteAuth.Master" AutoEventWireup="true" CodeBehind="ColumnAdmin.aspx.cs" Inherits="OpenEnvironment.App_Pages.Secure.ColumnAdmin" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function GetConfirmation() {
            var reply = confirm("WARNING: This will delete the Column Configuration - are you sure you want to continue?");
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



           function EditColumnData() {
               $("#lblTitle").text("Edit an Column Configuration");
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
    <asp:ObjectDataSource ID="dsColumnConfig" runat="server" SelectMethod="GetT_OE_ColumnConfig" TypeName="OpenEnvironment.App_Logic.DataAccessLayer.db_Config">
        <selectparameters>
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
                        <h2>Edit Column Configuration - <%=Session["OrgID"] %></h2>
                        <ul class="buttons">
                            <%-- <li><a href="#" class="block-refresh"><span class="fa fa-refresh"></span></a></li>
                            <li><a href="#" class="block-toggle"><span class="fa fa-chevron-down"></span></a></li>
                            <li><a href="#" class="block-remove"><span class="fa fa-times"></span></a></li>--%>
                        </ul>  
                    </div>

        <div class="block-content">

  
        
         <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary" Text="Add a Column Configuration" onclick="btnAdd_Click" />
        
        <asp:ImageButton ID="btnConfig" runat="server" Height="24px"  style="float:right; padding-right:5px; padding-left:5px" ImageUrl="~/App_Images/ico_config.png" />
      
       
           <asp:Label ID="lblMsg" runat="server" CssClass="failureNotification"></asp:Label>

           <div class="table-responsive">
             <asp:GridView ID="grdColumnConfig" 
                runat="server" 
                GridLines="None" 
                PagerStyle-CssClass="pgr"
                CssClass="table table-striped table-bordered"
                PageSize="6"
                AllowPaging="True"
                AutoGenerateColumns="False" 
                AlternatingRowStyle-CssClass="alt" 
                onrowcommand="grdColumnConfig_RowCommand" 
                onrowcancelingedit="grdColumnConfig_RowCancelingEdit" 
                onrowediting="grdColumnConfig_RowEditing" onrowupdating="grdColumnConfig_RowUpdating" OnPageIndexChanging="GridView1_PageIndexChanging"  >
                <Columns>
                    <asp:TemplateField HeaderText="Delete">
                        <ItemStyle HorizontalAlign="Center" Width="60px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edits"  data-toggle="modal" 
                                CommandArgument='<% #Eval("COLUMNCONFIG_IDX") %>' ImageUrl="~/App_Images/ico_edit.png"
                                ToolTip="Edit" />
                            <asp:ImageButton ID="DelButton" runat="server" CausesValidation="False" CommandName="Deletes" OnClientClick="return GetConfirmation();" 
                                CommandArgument='<% #Eval("COLUMNCONFIG_IDX") %>' ImageUrl="~/App_Images/ico_del.png"
                                ToolTip="Delete" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="COLUMN_NAME" HeaderText="Name" SortExpression="COLUMN_NAME" />
                    <asp:BoundField DataField="UNIT" HeaderText="Unit" SortExpression="UNIT" />
                    <asp:BoundField DataField="MAX_VALUE" HeaderText="Max Value" SortExpression="MAX VALUE" />
                    <asp:BoundField DataField="MIN_VALUE" HeaderText="Min Value" SortExpression="MIN_VALUE" />
                    <asp:BoundField DataField="COLUMN_DONT_SEND" HeaderText="Don't send to WQX" SortExpression="COLUMN_DONT_SEND" />
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
                        <h4 id="lblTitle" class="modal-title">Edit Column Config</h4>
                    </div>
                    <div class="modal-body">

    <p>
        <asp:Label ID="Label1" runat="server" CssClass="failureNotification"></asp:Label>
        <asp:Label ID="lblColumnCongifIDX" runat="server" Style="display:none"/>
    </p>
   
         <div class="form-group">
            <label>Column Name:</label>
            <asp:TextBox ID="txtColumnName"  MaxLength="50" runat="server"  placeholder="Column Name" title="Column Name" CssClass="form-control"/>
        </div>
        <div class="form-group">
            <label>Unit:</label>
            <asp:TextBox ID="txtUnit" runat="server" MaxLength="50" CssClass="form-control"/>
        </div>
         <div class="form-group">
            <label>Max Value:</label>
            <asp:TextBox ID="txtMaxValue" runat="server" MaxLength="50" CssClass="form-control"/>
        </div>
         <div class="form-group">
            <label>Min Value:</label>
            <asp:TextBox ID="txtMinValue" runat="server" MaxLength="50" CssClass="form-control"/>
        </div>
         <div class="form-group">
            <label>Don't Send to WQX:</label>
            <asp:CheckBox ID="chkColumnDontSend" runat="server" MaxLength="50" CssClass="form-control"/>
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