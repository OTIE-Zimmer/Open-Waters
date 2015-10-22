using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Configuration;
using System.Data;
using System.Data.SqlClient;

using OpenEnvironment.App_Logic.DataAccessLayer;
using OpenEnvironment.App_Logic.BusinessLogicLayer;

namespace OpenEnvironment.App_Pages.Secure
{
    public partial class WQXConfigurations : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                Trace.Write("starting Page Load");
                if (Session["TableDataSet"] != null) 
                { 
                    DataSet tds = Session["TableDataSet"] as DataSet;
                    Trace.Write(tds.ToString());
                    var tablenames = GetTablenames(tds.Tables);
                    sheetCombo.DataSource = tablenames;
                    sheetCombo.DataBind();
                    GridView1.DataSource = tds.Tables[sheetCombo.SelectedIndex];
                    GridView1.DataBind();
                    //columnCombo.DataSource = tds.Tables[sheetCombo.SelectedIndex].Columns;
                    //columnCombo.DataBind();
                    //Get the list of columns to be assigned from DB

                    foreach (DataColumn columnName in tds.Tables[sheetCombo.SelectedIndex].Columns)
                    {
                        Label myLabel = new Label();
                        myLabel.Text = columnName.ToString();
                        myLabel.ID = columnName.ToString() +"label";
                        myLabel.Width = 120;
                        myLabel.Height = 28;
                        columnPanel.Controls.Add(myLabel);

                        DropDownList myDropDownList = new DropDownList();
                        myDropDownList.ID = columnName.ToString() + "combo";

                        //Remove this once table lookup in place.
                        myDropDownList.DataSource = tds.Tables[sheetCombo.SelectedIndex].Columns;
                        myDropDownList.DataBind();
                        
                        //need to load data to control.  Following code is for proof of concept.
                        
                        Trace.Warn("starting DB read");
                        
                        myDropDownList.DataSource = dsColumn;
                        myDropDownList.Height = 28;
                        myDropDownList.DataValueField = "COLUMNCONFIG_IDX";
                        myDropDownList.DataTextField = "COLUMN_NAME";
                        myDropDownList.DataBind();

                        columnPanel.Controls.Add(myDropDownList);
                        //columnPanel.Controls.Add(new LiteralControl("<br/>")); 
                    }
                }
            }
            catch (Exception ex)
            {
                Trace.Warn("error caught.  " + ex.Message);
                //catch error code
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

        protected void sheetCombo_SelectedIndexChanged(object sender, EventArgs e)
        {
            //will need to write code to update the data grid
        }

        protected void btnSaveConfig_Click(object sender, EventArgs e)
        {
            if (configurationName.Text == "") 
            {
                Trace.Warn("Please enter a configuration name");
                return;
            }
            DataSet tds = Session["TableDataSet"] as DataSet;
            foreach (DataColumn columnName in tds.Tables[sheetCombo.SelectedIndex].Columns)
            {
                DropDownList myDropDownList = columnPanel.FindControl(columnName.ToString() + "combo") as DropDownList;
                Label myLabel = columnPanel.FindControl(columnName.ToString() + "label") as Label;
                
                Trace.Write(columnName.ToString() + "=" + myDropDownList.SelectedValue.ToString());
                Trace.Warn("InsertT_OE_SAVED_COLUMN_CONFIG(" + configurationName.Text + ", " + Session["OrgID"].ToString() + ", " + myDropDownList.SelectedValue.ToString() + ", " + myLabel.Text + ")");
                int returnVal = db_Config.InsertT_OE_SAVED_COLUMN_CONFIG(configurationName.Text, Session["OrgID"].ToString(), Convert.ToInt32(myDropDownList.SelectedValue), myLabel.Text);

                Trace.Warn("returnVal = " + returnVal.ToString());
            }
        }

        //protected void columnCombo_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    //will need to write code to update the data grid
        //}
    }
}