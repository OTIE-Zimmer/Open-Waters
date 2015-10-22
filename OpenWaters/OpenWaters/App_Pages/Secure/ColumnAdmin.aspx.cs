using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpenEnvironment.App_Logic.BusinessLogicLayer;
using OpenEnvironment.App_Logic.DataAccessLayer;

using ICSharpCode.SharpZipLib;
using ICSharpCode;
using Excel;
using System.IO;
using System.Data;

using System.ComponentModel;
using System.Drawing;
using System.Globalization;
using System.Text;
//using System.Threading;
//using System.Threading.Tasks;

namespace OpenEnvironment.App_Pages.Secure
{
    public partial class ColumnAdmin : System.Web.UI.Page
    {
        DataSet ds = new DataSet();


        protected void Page_PreRender(object o, System.EventArgs e)
        {
            FillGrid();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //display left menu as selected
                //grdColumnConfig.Columns[4].Visible = (Session["PROJ_SAMP_DESIGN_TYPE_CD"].ConvertOrDefault<Boolean>());
                //grdColumnConfig.Columns[5].Visible = (Session["PROJ_QAPP_APPROVAL"].ConvertOrDefault<Boolean>());
                //grdColumnConfig.Columns[6].Visible = (Session["PROJ_QAPP_APPROVAL"].ConvertOrDefault<Boolean>());

                if (HttpContext.Current.User.IsInRole("READONLY"))
                {
                    //btnAdd.Enabled = false;
                    grdColumnConfig.Columns[0].Visible = false;
                }
                //Edit Part
            }

        }



        protected void Timer1_Tick(object sender, EventArgs e)
        {

        }

        public static string GetImage(string value, Boolean WQXInd)
        {
            if (WQXInd)
            {
                if (value == "U")
                    return "~/App_Images/progress.gif";
                else if (value == "N")
                    return "~/App_Images/ico_alert.png";
                else if (value == "Y")
                    return "~/App_Images/ico_pass.png";
                else
                    return "~/App_Images/ico_alert.png";
            }
            else
            {
                return "~/App_Images/0.png";
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            Session.Add("ColumnConfigIDX", 0);

            lblColumnCongifIDX.Text = "";
            txtColumnName.Text = "";
            txtUnit.Text = "";
            txtMaxValue.Text = "";
            txtMinValue.Text = "";
            chkColumnDontSend.Checked = false;
            
            AddColumnConfigData();
        }

        protected void btnConfigSave_Click(object sender, EventArgs e)
        {
            Response.Redirect(Page.Request.Url.ToString(), true);
        }

        protected void grdColumnConfig_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int ProjectID = Convert.ToInt32(e.CommandArgument.ToString());
            if (e.CommandName == "Edits")
            {
                Session.Add("ColumnConfigIDX", e.CommandArgument.ToString());
                Trace.Warn("Edit");

                T_OE_COLUMNCONFIG m = db_Config.GetT_OE_COLUMNCONFIG_VALUE(Session["ColumnConfigIDX"].ConvertOrDefault<int>());
                if (m != null)
                {
                    lblColumnCongifIDX.Text = m.COLUMNCONFIG_IDX.ToString();
                    txtColumnName.Text = m.COLUMN_NAME;
                    txtUnit.Text = m.UNIT;
                    txtMinValue.Text = m.MIN_VALUE.ToString();
                    txtMaxValue.Text = m.MAX_VALUE.ToString();
                    chkColumnDontSend.Checked = m.COLUMN_DONT_SEND.ConvertOrDefault<Boolean>();
                }
                else
                {
                    lblColumnCongifIDX.Text = "";
                }
                EditProjectData();
                //  Response.Redirect("~/App_Pages/Secure/WQXProjectEdit.aspx");
            }

            if (e.CommandName == "Deletes")
            {
                int ColumnConfigID = Convert.ToInt32(e.CommandArgument.ToString());

                Trace.Warn("Delete");
                db_Config.DeleteT_OE_ColumnConfig(ColumnConfigID);
                //List<T_WQX_ACTIVITY> a = db_WQX.GetWQX_ACTIVITY(false, Session["OrgID"].ConvertOrDefault<string>(), null, null, null, null, false, ProjectID);
                //if (a.Count == 0)
                //{
                //    db_WQX.DeleteT_WQX_PROJECT(ProjectID);
                //    lblMsg.Text = "";
                //    FillGrid();
                //}
                //else
                //    lblMsg.Text = "You cannot delete a project that has samples/activities. You can instead make the project inactive at the project details screen.";
            }

            if (e.CommandName == "WQX")
            {
                Session.Add("TableCD", "PROJ");
                Session.Add("ColumnConfigIDX", e.CommandArgument.ToString());
                //Response.Redirect("~/App_Pages/Secure/WQX_Hist.aspx");
            }

        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdColumnConfig.PageIndex = e.NewPageIndex;
            grdColumnConfig.DataBind();
        }

        public void FillGrid()
        {
            grdColumnConfig.DataSource = dsColumnConfig;
            grdColumnConfig.DataBind();
        }

        protected void grdColumnConfig_RowEditing(object sender, GridViewEditEventArgs e)
        {
            grdColumnConfig.EditIndex = e.NewEditIndex;
        }

        protected void grdColumnConfig_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            grdColumnConfig.EditIndex = -1;
        }

        protected void grdColumnConfig_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
        }

        //Code for Excel Importer


        protected void grdImport_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Deletes")
            {
                db_Ref.DeleteT_WQX_IMPORT_LOG(e.CommandArgument.ToString().ConvertOrDefault<int>());
                Response.Redirect("~/App_Pages/Secure/ExcelImporter.aspx");
            }

        }


        private void AddColumnConfigData()
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine("$(document).ready(function() {");
            sb.AppendLine("$('#lblTitle').text('Add a Column');");
            sb.AppendLine("$('#myEditTemplate').modal();");
            //sb.AppendLine("$('#gridArea').hide();");
            sb.AppendLine("});");

            Page.ClientScript.RegisterStartupScript(this.GetType(), "EditData", sb.ToString(), true);
        }

        private void EditProjectData()
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine("$(document).ready(function() {");
            sb.AppendLine("$('#lblTitle').text('Edit a Project');");
            sb.AppendLine("$('#myEditTemplate').modal();");

            //sb.AppendLine("$('#gridArea').hide();");
            sb.AppendLine("});");

            Page.ClientScript.RegisterStartupScript(this.GetType(), "EditData", sb.ToString(), true);
        }


        private IList<string> GetTablenames(DataTableCollection tables)
        {
            var tableList = new List<string>();
            foreach (var table in tables)
            {
                tableList.Add(table.ToString());
            }

            return tableList;
        }

        //Project Edit Code
        protected void btnSave_Click(object sender, EventArgs e)
        {
            Trace.Warn("Save");
            //save updates to Project
            int SuccID = db_Config.InsertOrUpdateT_OE_ColumnConfig(lblColumnCongifIDX.Text.ConvertOrDefault<int?>(), txtColumnName.Text, txtUnit.Text, txtMaxValue.Text.ConvertOrDefault<Double>(),
                    txtMinValue.Text.ConvertOrDefault<Double>(), chkColumnDontSend.Checked.ConvertOrDefault<Boolean>());

            Trace.Warn("Column Config ID return value=" + SuccID.ToString());
            if (SuccID > 0)
            {
                //    // Response.Redirect("~/App_Pages/Secure/WQXProject.aspx");
            }

            else
                lblMsg.Text = "Error updating record.";
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Trace.Warn("Cancel");
            // Response.Redirect("~/App_Pages/Secure/WQXProject.aspx");
        }

    }
}