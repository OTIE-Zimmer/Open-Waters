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
    public partial class AnalyzeAdmin : System.Web.UI.Page
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
                grdAnalyzeConfig.Columns[4].Visible = (Session["PROJ_SAMP_DESIGN_TYPE_CD"].ConvertOrDefault<Boolean>());
                grdAnalyzeConfig.Columns[5].Visible = (Session["PROJ_QAPP_APPROVAL"].ConvertOrDefault<Boolean>());
                grdAnalyzeConfig.Columns[6].Visible = (Session["PROJ_QAPP_APPROVAL"].ConvertOrDefault<Boolean>());

                if (HttpContext.Current.User.IsInRole("READONLY"))
                {
                    //btnAdd.Enabled = false;
                    grdAnalyzeConfig.Columns[0].Visible = false;
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
            Session.Add("ANALYZECONFIGIDX", 0);

            lblAnalyzeCongifIDX.Text = "";
            txtAnalyzeConfigName.Text = "";
            txtSites.Text = "";
            txtCharacteristic.Text = "";
            txtStartDate.Text = "";
            txtEndDate.Text = "";
            txtUpperThreshold.Text = "";
            txtLowerThreshold.Text = "";

            AddAnalyzeConfigData();
        }

        protected void btnConfigSave_Click(object sender, EventArgs e)
        {
            Response.Redirect(Page.Request.Url.ToString(), true);
        }
               
        protected void grdAnalyzeConfig_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //int ProjectID = Convert.ToInt32(e.CommandArgument.ToString());
            if (e.CommandName == "Edits")
            {
                Session.Add("ANALYZECONFIGIDX", e.CommandArgument.ToString());
                Trace.Warn("Edit");

                T_OE_ANALYZECONFIG m = db_Config.GetT_OE_AnalyzeConfig_ByID(Session["ANALYZECONFIGIDX"].ConvertOrDefault<int>());
                if (m != null)
                {
                    lblAnalyzeCongifIDX.Text = m.ANALYZECONFIG_IDX.ToString();
                    txtAnalyzeConfigName.Text = m.ANALYZECONFIG_NAME;
                    txtSites.Text = m.SITES;
                    txtCharacteristic.Text = m.CHARACTERISTIC;
                    txtStartDate.Text = m.START_DATE.ToString();
                    txtEndDate.Text = m.END_DATE.ToString();
                    txtUpperThreshold.Text = m.UPPER_THRESHOLD.ToString();
                    txtLowerThreshold.Text = m.LOWER_THRESHOLD.ToString();
                }
                else
                {
                    lblAnalyzeCongifIDX.Text = "";
                }
                EditAnalyzeConfigData();
                //  Response.Redirect("~/App_Pages/Secure/WQXProjectEdit.aspx");
            }

            if (e.CommandName == "Deletes")
            {
                int AnalyzeConfigID = Convert.ToInt32(e.CommandArgument.ToString());

                Trace.Warn("Delete");
                db_Config.DeleteT_OE_AnalyzeConfig(AnalyzeConfigID);
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
                Session.Add("ANALYZECONFIGIDX", e.CommandArgument.ToString());
                //Response.Redirect("~/App_Pages/Secure/WQX_Hist.aspx");
            }

        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {

            grdAnalyzeConfig.PageIndex = e.NewPageIndex;

            grdAnalyzeConfig.DataBind();

        }

        public void FillGrid()
        {
            grdAnalyzeConfig.DataSource = dsAnalyzeConfig;
            grdAnalyzeConfig.DataBind();
        }

        protected void grdAnalyzeConfig_RowEditing(object sender, GridViewEditEventArgs e)
        {
            grdAnalyzeConfig.EditIndex = e.NewEditIndex;
        }

        protected void grdAnalyzeConfig_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            grdAnalyzeConfig.EditIndex = -1;
        }

        protected void grdAnalyzeConfig_RowUpdating(object sender, GridViewUpdateEventArgs e)
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


        private void AddAnalyzeConfigData()
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine("$(document).ready(function() {");
            sb.AppendLine("$('#lblTitle').text('Add an Analyze Config');");
            sb.AppendLine("$('#myEditTemplate').modal();");
            //sb.AppendLine("$('#gridArea').hide();");
            sb.AppendLine("});");

            Page.ClientScript.RegisterStartupScript(this.GetType(), "EditData", sb.ToString(), true);
        }

        private void EditAnalyzeConfigData()
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine("$(document).ready(function() {");
            sb.AppendLine("$('#lblTitle').text('Edit an Analyze Config');");
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
            int SuccID = db_Config.InsertOrUpdateT_OE_AnalyzeConfig(lblAnalyzeCongifIDX.Text.ConvertOrDefault<int?>(), Session["OrgID"].ToString(), txtAnalyzeConfigName.Text, Session["UserIDX"].ConvertOrDefault<Int32>(), txtSites.Text, txtCharacteristic.Text,
                    txtStartDate.Text.ConvertOrDefault<DateTime>(), txtEndDate.Text.ConvertOrDefault<DateTime>(), txtUpperThreshold.Text.ConvertOrDefault<Double>(), txtLowerThreshold.Text.ConvertOrDefault<Double>());

            Trace.Warn("Analyze Config ID return value=" + SuccID.ToString());
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