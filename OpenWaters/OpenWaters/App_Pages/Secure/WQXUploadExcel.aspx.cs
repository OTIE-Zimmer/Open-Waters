
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Services.Protocols;

using OpenEnvironment.App_Logic.DataAccessLayer;
using OpenEnvironment.App_Logic.BusinessLogicLayer;

using ICSharpCode.SharpZipLib;
using ICSharpCode;
using Excel;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

using System.ComponentModel;
using System.Drawing;
using System.Globalization;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace OpenEnvironment.App_Pages.Secure
{
    public partial class WQXUploadExcel : System.Web.UI.Page
    {
        DataSet ds = new DataSet();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Don't reload the Project and Template drop downs.
                ddlProject.DataSource = dsProject;
                ddlProject.DataValueField = "PROJECT_IDX";
                ddlProject.DataTextField = "PROJECT_NAME";
                ddlProject.DataBind();

                ddlTemplate.DataSource = dsTemplate;
                ddlTemplate.DataValueField = "CONFIG_NAME";
                ddlTemplate.DataTextField = "CONFIG_NAME";
                ddlTemplate.DataBind();
            }
            if (Session["TableDataSet"] !=null)
            {
                //file exists in session state.  Allow user to migrate to DB without reloading the file.
                if (sheetCombo.DataSource == null)
                {
                    ds = Session["TableDataSet"] as DataSet;

                    var tablenames = GetTablenames(ds.Tables);
                    sheetCombo.DataSource = tablenames;
                    sheetCombo.DataBind();

                    if (tablenames.Count > 0)
                        sheetCombo.SelectedIndex = 0;

                    GridView1.DataSource = ds.Tables[0];
                    GridView1.DataBind();
                }
                ShowUpladData();
            }
        }

        //Upload Code

        //protected void BtnSubmit_Click(object sender, EventArgs e)
        //{
        //    dataUpload();
        //}

        private void ShowUpladData()
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine("$(document).ready(function() {");
            sb.AppendLine("$('#datUploadResults').show();");
            //sb.AppendLine("$('#pnlum').addClass('hidden');");
            //sb.AppendLine("$('#gridArea').hide();");
            sb.AppendLine("});");

            Page.ClientScript.RegisterStartupScript(this.GetType(), "EditData", sb.ToString(), true);
        }

        //Upload File Code
        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                try
                {
                    string filename = Path.GetFileName(FileUpload1.FileName);
                    FileUpload1.SaveAs(Server.MapPath("~/EBCIUploads/") + FileUpload1.FileName);
                    //StatusLabel.Text = "Upload status: File uploaded!";
                    dataUpload();
                    lblMessage.Text = "File successfully uploaded";
                    divMessageArea.Visible = true;
                }
                catch (Exception ex)
                {
                    //This exception is being caught.
                    Trace.Warn("Exception 1.  Message=" + ex.Message); //Added by Chuck for debugging purposes
                }
            }
        }

        protected void dataUpload()
        {
            if (FileUpload1.HasFile)
            {
                //string Extension = Path.GetExtension(FileUpload1.PostedFile.FileName);
                string path = Path.GetFileName(FileUpload1.PostedFile.FileName);

                //var fullPath = path; // 
                var fullPath = Server.MapPath("~/EBCIUploads/") + path;
                var file = new FileInfo(path);

                Trace.Warn("Full Path=" + fullPath);
                using (FileStream stream = new FileStream(fullPath, FileMode.Open, FileAccess.Read))
                {
                    IExcelDataReader reader = null;
                    if (file.Extension == ".xls")
                    {
                        reader = ExcelReaderFactory.CreateBinaryReader(stream);

                    }
                    else if (file.Extension == ".xlsx")
                    {
                        reader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                    }
                    
                    if (reader == null)
                        return;

                    reader.IsFirstRowAsColumnNames = true;
                    ds = reader.AsDataSet();

                    Session["TableDataSet"] = ds;

                    var tablenames = GetTablenames(ds.Tables);
                    sheetCombo.DataSource = tablenames;
                    sheetCombo.DataBind();

                    if (tablenames.Count > 0)
                        sheetCombo.SelectedIndex = 0;

                    GridView1.DataSource = ds.Tables[0];
                    GridView1.DataBind();
                }
                //make the migrate section of the website visible.
                ShowUpladData();
            }
            else
            {
                LblError.Text = "Unable to upload the selected file. Please check the selected file path or confirm that the file is not blank!";
            }
        }

        //private void checkExpression(object sender, EventArgs e)
        //{
        //    Regex obj = new Regex(txtPattern.Text);
        //    MessageBox.Show(obj.IsMatch(txtData.Text).ToString());
        //}

        //Monitor Location Parser

        protected void Process_Click(object sender, EventArgs e)
        {
            //TODO: add logic to check which sheet is selected.
            //Get the data from the previously uploaded file.
            
            if (ddlProject.SelectedValue.ToString().Trim() == "")
            {
                Trace.Warn("Project is blank.  Don't save.");
                lblMessage.Text += "<br> Please select a project before trying to save the results.  If you don't have any projects to choose from, please create a project.";
               
                return;
            }

            DataSet mds = Session["TableDataSet"] as DataSet;

            //MonLoc Parameters.  These are commented out as monitoring locations are not being created or updated on this page.
            //String MonitoringLocationDescriptionText = "";
            //String HUCEightDigitCode = "";
            //String HUCTwelveDigitCode = "";
            //String TribalLandName="";
            
            //String SourceMapScaleNumeric = "";
            //String HorizontalCoordinateReferenceSystemDatumName = null;
            //String VerticalMeasureValue="";
            //String VerticalMeasureUnitCode="";
            //String VerticalCollectionMethodName="";
            //String VerticalCoordinateReferenceSystemDatumName="";
            //String WellFormationTypeText="";
               
            //Activity Parameters
            DateTime ActivityStartDate;
            DateTime ActivityEndDate;

            try
            {
                bool validRow = true;
                //Get user defined column names for key fields
                string stationID_Col_Name = db_Config.GetT_OE_SAVED_COLUMN_CONFIG_Name(db_Config.GetT_OE_COLUMNCONFIG_ID("Station ID"));
                //string station_Name = db_Config.GetT_OE_SAVED_COLUMN_CONFIG_Name(db_Config.GetT_OE_COLUMNCONFIG_ID("Station Name"));
                //string medium_Name = db_Config.GetT_OE_SAVED_COLUMN_CONFIG_Name(db_Config.GetT_OE_COLUMNCONFIG_ID("Medium"));
                string activity_Date_Name = db_Config.GetT_OE_SAVED_COLUMN_CONFIG_Name(db_Config.GetT_OE_COLUMNCONFIG_ID("Activity Date"));
                string time_Name = db_Config.GetT_OE_SAVED_COLUMN_CONFIG_Name(db_Config.GetT_OE_COLUMNCONFIG_ID("Time"));
                string sample_Collection_Name = db_Config.GetT_OE_SAVED_COLUMN_CONFIG_Name(db_Config.GetT_OE_COLUMNCONFIG_ID("Sample collection"));
                //string latitude_Name = db_Config.GetT_OE_SAVED_COLUMN_CONFIG_Name(db_Config.GetT_OE_COLUMNCONFIG_ID("Latitude"));
                //string longitude_Name = db_Config.GetT_OE_SAVED_COLUMN_CONFIG_Name(db_Config.GetT_OE_COLUMNCONFIG_ID("Longitude"));

                //variables to hold values for fields to be applied to each collection value in the row.
                string stationID_Col_Val;
                //string station_Val;
                //string medium_Val;
                string activity_Date_Val;
                string time_Val;
                string sample_Collection_Val;
                //string latitude_Val;
                //string longitude_Val;
                lblMessage.Text = ""; //Reset the message so any errors can be skipped.
                for (int i = 0; i < mds.Tables[0].Rows.Count; i++)
                {
                    //check if row is null or 1st cell is null.  Once either is true, stop adding monitoring locations to DB.
                    if (validRow == false || mds.Tables[0].Rows[i] == null || Convert.ToString(mds.Tables[0].Rows[i].ItemArray[0]).Trim() == "")
                    {
                        validRow = false;
                    }

                    //Only add monitoring locations while validRow is true.
                    if (validRow)
                    {
                        Trace.Warn("i=" + i);
                        //retrieve common values from uploaded file to be stored.
                        stationID_Col_Val = Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(stationID_Col_Name)]).Trim();
                        //station_Val = Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(station_Name)]).Trim();
                        //medium_Val = Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(medium_Name)]).Trim();
                        activity_Date_Val = Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(activity_Date_Name)]).Trim();
                        time_Val = Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(time_Name)]).Trim();
                        sample_Collection_Val = Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(sample_Collection_Name)]).Trim();
                        if (DateTime.TryParse(activity_Date_Val, out ActivityStartDate))
                        {
                            Trace.Warn("Date String.  " + ActivityStartDate.ToString());
                        }
                        else
                        {   
                            DateTime temp = new DateTime(1899, 12, 31).AddDays(Convert.ToInt32(activity_Date_Val) -1);
                            ActivityStartDate = temp;
                            Trace.Warn("Excel Serial Date.  " + ActivityStartDate.ToString());
                        }
                        ActivityEndDate = ActivityStartDate;
                        //ActivityStartDate = Convert.ToDateTime(activity_Date_Val);
                        //ActivityEndDate = Convert.ToDateTime(activity_Date_Val);
                        //latitude_Val = Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(latitude_Name)]).Trim();
                        //longitude_Val = System.Text.RegularExpressions.Regex.Replace(Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(longitude_Name)]).Trim(), "[()]", "");

                        //lookup the monitoring location ID.
                        int? MonLocIDX = db_WQX.GetWQX_MONLOCIDX_BySite(stationID_Col_Val);
                        if (MonLocIDX == null) //Don't save results if Monitoring Location doesn't exist in DB.
                        {
                            Trace.Warn("Monitoring Location is not found.  Don't save.");
                            lblMessage.Text += "<br> Monitoring Location " + stationID_Col_Val + " is not found.  Please create this monitoring location prior to loading activity results for the monitoring location.";
                        }
                        else 
                        {
                            //lookup the activity ID.  If one doesn't exist, create one.
                            int? ActID;
                            var uniqueSampleID = stationID_Col_Val + ":" + ActivityStartDate.ToString("YYYYMMDD") + ":" + time_Val + ":" + sample_Collection_Val;
                            Trace.Warn("uniqueSampleID = " + uniqueSampleID);
                            T_WQX_ACTIVITY a = db_WQX.GetWQX_ACTIVITY_ByUnique(Session["OrgID"].ToString(), uniqueSampleID);
                            if (a != null)
                            {
                                ActID = a.ACTIVITY_IDX;
                                Trace.Warn("Preexisting activity ID found.  ID =" + ActID.ToString());
                            }
                            else
                            {
                                ActID = null;
                                Trace.Warn("No preexisting activity found.  uniqueSampleID=" + uniqueSampleID);
                            }
                            Trace.Warn("Project ID=" + ddlProject.SelectedValue.ToString());
                            ActID = db_WQX.InsertOrUpdateWQX_ACTIVITY(ActID, Session["OrgID"].ToString(), Convert.ToInt32(ddlProject.SelectedValue.ToString()), MonLocIDX, uniqueSampleID, "Field Msr/Obs-Habitat Assessment", "Water", null, ActivityStartDate.ConvertOrDefault<DateTime>(), null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
                              null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null,
                              "U", true, true, User.Identity.Name, "H");
        
                            Trace.Warn("ACTID=" + ActID);
                            //This is commented out as a Monitoring Location needs to be setup prior to saving the record (business decision).  This code is working correctly
                            //save updates to Mon Loc.  
                            //if (!MonLocIDX.HasValue)
                            //{
                            //    lblMessage.Text += "<br> This Monitoring Location, " + stationID_Col_Val + ", will be added.  Please make sure all location details are entered in the Admin screens.";
                            //}
                            //else
                            //{ 
                            //    Trace.Warn("Monitoring Locaiton exists.  Monitoring Location = " + MonLocIDX.GetValueOrDefault());
                            //}
                            //int SuccIDMonLoc = db_WQX.InsertOrUpdateWQX_MONLOC(MonLocIDX, Session["OrgID"].ToString(), stationID_Col_Val, station_Val,
                            //    medium_Val, MonitoringLocationDescriptionText, HUCEightDigitCode, HUCTwelveDigitCode, null, TribalLandName, latitude_Val, longitude_Val,
                            //    SourceMapScaleNumeric.ConvertOrDefault<int?>(), null, null, sample_Collection_Val, HorizontalCoordinateReferenceSystemDatumName, VerticalMeasureValue,
                            //    VerticalMeasureUnitCode, VerticalCollectionMethodName, VerticalCoordinateReferenceSystemDatumName, null, null, null,
                            //    WellFormationTypeText, null, null, null, null, "U", null, true, true, User.Identity.Name);
                            //Trace.Warn("Monitoring Location ID=" + SuccIDMonLoc);

                            int ActID2 = ActID.ConvertOrDefault<int>();

                            List<string> charstc_Names = GetCharstc();
                            foreach (string charstc in charstc_Names)
                            {
                                //i is row
                                string sampleValue = "";
                                string sampleUnit = "";
                                string sampleWQXName = "";
                                bool sendToWQX = false;
                                T_OE_COLUMNCONFIG row = db_Config.GetT_OE_COLUMNCONFIG_VALUE(db_Config.GetT_OE_SAVED_COLUMN_CONFIG_WQXID(Session["OrgID"].ToString(), ddlTemplate.SelectedValue.ToString(), charstc));
                                sampleWQXName = row.COLUMN_NAME.Trim();//db_Config.GetT_OE_COLUMNCONFIG_Name(db_Config.GetT_OE_SAVED_COLUMN_CONFIG_WQXID(Session["OrgID"].ToString(), ddlTemplate.SelectedValue.ToString(), charstc));
                            
                                //Ignore values that need to be added to each record or should be skipped (Do Not Send)
                                switch (sampleWQXName)
                                {
                                    case "Station ID":
                                    case "Station Name":
                                    case "Medium":
                                    case "Activit Date":
                                    case "Time":
                                    case "Sample collection":
                                    case "Latitude":
                                    case "Longitude":
                                    case "Depth (m)":
                                    case "Do Not Send":
                                    case "":
                                        break;
                                    default:
                                        sampleValue = Convert.ToString(mds.Tables[0].Rows[i].ItemArray[mds.Tables[0].Columns.IndexOf(charstc)]).Trim();
                                        if (sampleValue.Length > 0) //don't try to send for values that are blank.
                                        {
                                            Trace.Warn("charst = " + charstc);
                                            Trace.Warn("db_Config.GetT_OE_COLUMNCONFIG_ID(" + charstc + ", " + Session["OrgID"].ToString() + ", " + ddlTemplate.SelectedValue.ToString() + ")");
                                            Trace.Warn("ColumnID=" + db_Config.GetT_OE_COLUMNCONFIG_ID(charstc, Session["OrgID"].ToString(), ddlTemplate.SelectedValue.ToString()));
                                            sampleUnit = row.UNIT;//db_Config.GetT_OE_COLUMNCONFIG_Unit(db_Config.GetT_OE_COLUMNCONFIG_ID(charstc, Session["OrgID"].ToString(), ddlTemplate.SelectedValue.ToString()));

                                            sendToWQX = !row.COLUMN_DONT_SEND.GetValueOrDefault();//db_Config.GetT_OE_COLUMNCONFIG_SEND_TO_WQX(sampleWQXName);
                                            Trace.Warn("db_WQX.InsertOrUpdateT_WQX_RESULT(null, " + ActID2 + ", " + sampleWQXName + ", " + sampleValue + ", " + sampleUnit + ", null, , , null, null,  , null, " + User.Identity.Name);

                                            Trace.Warn("column " + sampleWQXName + "send to WQX = " + sendToWQX.ToString());

                                            bool dontSend = false;  //Validate values are reasonable.
                                        
                                            double placeholder=0;
                                            if (!double.TryParse(sampleValue, out placeholder))  //The value isn't a number.  Don't load in db
                                            {
                                                Trace.Warn(row.COLUMN_NAME + " is below min value");
                                                lblMessage.Text += "<br>" + charstc + " in row " + (i + 1) + " Is not a numeric value.  Only numeric values will be saved. ";
                                                dontSend = true;
                                            }
                                            else
                                            {
                                                if (row.MIN_VALUE.HasValue)  //There is a minimum value check
                                                {
                                                    Trace.Warn("min_value is not blank");
                                                    if (Convert.ToDouble(sampleValue) < row.MIN_VALUE.GetValueOrDefault()) //Sample values is below minimum
                                                    {
                                                        Trace.Warn(row.COLUMN_NAME + " is below min value");
                                                        lblMessage.Text += "<br>" + charstc + " in row " + (i + 1) + " is below the minimum value of " + row.MIN_VALUE.GetValueOrDefault() + " so it was skipped.";
                                                        dontSend = true;
                                                    }
                                                }
                                                if (row.MAX_VALUE.HasValue) //There is a maximum value check
                                                {
                                                    Trace.Warn("max_value is not blank");
                                                    if (Convert.ToDouble(sampleValue) > row.MAX_VALUE.GetValueOrDefault()) //Sample value is above maximum
                                                    {
                                                        Trace.Warn(row.COLUMN_NAME + " is above the max value of " + row.MAX_VALUE.GetValueOrDefault());
                                                        lblMessage.Text += "<br>" + charstc + " in row " + (i + 1) + " is above the maximum value of " + row.MAX_VALUE.GetValueOrDefault() + " so it was skipped.";
                                                        dontSend = true;
                                                    }
                                                }
                                            }
                                            //TODO: add notice to lblMessage if value wasn't sent.
                                            //TODO: fix InsertOrUpdateT_WQX_RESULT so that it will update when it should.  Need to pass result ID.
                                            //TODO: Add code to DB to not send value to WQX
                                            if (!dontSend)
                                            {    
                                                int resultID = db_WQX.InsertOrUpdateT_WQX_RESULT(null, ActID2, null, sampleWQXName, null, sampleValue, sampleUnit,  "Final", null,  null, "", null, null, null, null, null, null, null, null, null, null, null, User.Identity.Name);
                                                                                         
                                                Trace.Warn("resultID=" + resultID);   
                                            }
                                        }
                                        break;
                                }

                            }
                        }
                    }
                }

                Trace.Warn("complete");

                lblMessage.Text += "<br>File successfully migrated to DB.";
                divMessageArea.Visible = true;
                //db_Ref.InsertUpdateWQX_IMPORT_LOG(null, Session["OrgID"].ToString(), "Activity", ddlMonLoc.SelectedValue, 0, "Success", null, User.Identity.Name);
            }
            catch (Exception ex)
            {
                Trace.Warn(ex.Message);
                lblMessage.Text += "<br> <b><font color='red'>There was an error processing the file.  Please verify the configuration you selected matches the file format exactly.</font></b>";

                //db_Ref.InsertUpdateWQX_IMPORT_LOG(null, Session["OrgID"].ToString(), ddlMonLoc.SelectedValue, ddlMonLoc.SelectedValue, 0, "Fail", null, User.Identity.Name,null,null);
            }
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

        private void SelectTable()
        {
            DataSet tds = Session["TableDataSet"] as DataSet;

            GridView1.DataSource = tds.Tables[sheetCombo.SelectedIndex];
            GridView1.DataBind();
            //make the migrate section of the website visible.
            ShowUpladData();
        }

        protected void sheetCombo_SelectedIndexChanged(object sender, EventArgs e)
        {
            SelectTable();
        }

        //TODO: Can this function be removed?
        //Web method used for retrieving sites to place on map
        [WebMethod(EnableSession = true)]
        public static string[] GetSites()
        {
            string _org = HttpContext.Current.Session["OrgID"].ConvertOrDefault<string>();
            List<string> myCollection = new List<string>();

            List<T_WQX_MONLOC> ms = db_WQX.GetWQX_MONLOC(true, _org, false);

            if (ms != null)
            {
                foreach (T_WQX_MONLOC m in ms)
                {
                    string samps = "";
                    string comments = "";
                    V_WQX_ACTIVITY_LATEST l = db_WQX.GetV_WQX_ACTIVITY_LATESTByMonLocID(m.MONLOC_IDX);

                    myCollection.Add(m.LATITUDE_MSR + "|" + m.LONGITUDE_MSR + "|" + m.MONLOC_NAME + " - " + m.MONLOC_TYPE + "|" + m.MONLOC_DESC + "<br/>" + comments + samps + "|" + m.MONLOC_ID + "|" + m.STATE_CODE + "|" + "test" + "|" + "test2");
                }
            }
            return myCollection.ToArray(); ;
        }

        //Returns a string list of user column names in this template.
        public List<string> GetCharstc()
        {
            List<T_OE_SAVED_COLUMN_CONFIG> userColumns = db_Config.GetT_OE_SAVED_COLUMN_CONFIG(Session["OrgID"].ToString(), ddlTemplate.SelectedValue.ToString());
            var colList = new List<string>();
            foreach (T_OE_SAVED_COLUMN_CONFIG row in userColumns)
            {
                colList.Add(row.USER_COL_NAME);
                //Lookup the WQX mapped column name
                //string colName = db_Config.GetT_OE_COLUMNCONFIG_Name(row.WQX_COL_ID.GetValueOrDefault());
                //if (colName != "Do Not Send")
                //    colList.Add(colName);
            }
            return colList;
        }
    }
}