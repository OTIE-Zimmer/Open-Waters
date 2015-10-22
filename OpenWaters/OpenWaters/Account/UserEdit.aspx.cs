using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;
using OpenEnvironment.App_Logic.DataAccessLayer;

namespace OpenEnvironment
{
    public partial class UserEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //displays the left menu as selected
                ContentPlaceHolder cp = this.Master.FindControl("MainContent") as ContentPlaceHolder;
                HyperLink hl = (HyperLink)cp.FindControl("lnkUserList");
                if (hl != null)
                    hl.CssClass = "on";

                // forms-based authorization
                if (!HttpContext.Current.User.IsInRole("ADMINS"))
                    Response.Redirect("~/App_Pages/Public/AccessDenied.aspx");

                int UserID = int.Parse((Session["UserEditID"] ?? "-1").ToString());

                PopulateForm(UserID);
            }
        }

        private void PopulateForm(int UserID)
        {
            T_OE_USERS u = db_Accounts.GetT_OE_USERSByIDX(UserID);
            if (u != null)
            {
                txtUserIDX.Text = u.USER_IDX.ToString();
                txtUserID.Text = u.USER_ID;
                txtFName.Text = u.FNAME;
                txtLName.Text = u.LNAME;
                txtEmail.Text = u.EMAIL;
                txtPhone.Text = u.PHONE;
                txtPhoneExt.Text = u.PHONE_EXT;
                chkActive.Checked = u.ACT_IND;
                pnlPwd.Visible = false;
            }
            else //add new case
            {
                txtUserID.Enabled = true;
                btnDelete.Visible = false;
                chkActive.Checked = true;
                pnlPwd.Visible = true;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/UserList.aspx");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                int SuccID;

                if (txtUserIDX.Text.Length > 0)
                    //update existing user
                    SuccID = db_Accounts.UpdateT_OE_USERS(int.Parse(txtUserIDX.Text), null, null, txtFName.Text, txtLName.Text, txtEmail.Text, chkActive.Checked, null, null, null, txtPhone.Text, txtPhoneExt.Text, User.Identity.Name);
                else
                {
                    //create new user
                    if (txtPassword.Text.Length == 0 || txtFName.Text.Length == 0 || txtLName.Text.Length == 0 || txtUserID.Text.Length == 0)
                    {
                        lblMsg.Text = "You must supply a user ID, user's name, and password.";
                        lblMsg.ForeColor = System.Drawing.Color.Red; 
                        return;
                    }

                    //first create user
                    //This failed for me with error message invalid email despite having a vaild email address.
                    MembershipCreateStatus t;
                    Trace.Warn("Membership.CreateUser(" + txtUserID.Text + ", " + txtPassword.Text + ", " + txtEmail.Text.ToLower() + ", null, null, true, out t);");
                    Membership.CreateUser(txtUserID.Text, txtPassword.Text, txtEmail.Text.ToLower(), null, null, true, out t);
                    
                    Trace.Warn("CreateUser Message=" + GetErrorMessage(t));
                    if (t == MembershipCreateStatus.InvalidPassword)
                    {
                        lblMsg.Text = "Invalid password. Password must be at least 8 characters long.";
                        lblMsg.ForeColor = System.Drawing.Color.Red; 
                        return;
                    }
                    //Added the two following lines to overcome issue with Membership.CreateUser
                    string salt = GenerateSalt();
                    db_Accounts.CreateT_OE_USERS(txtUserID.Text, HashPassword(txtPassword.Text, salt), salt, txtFName.Text, txtLName.Text, txtEmail.Text.ToLower(), true, false, System.DateTime.Now, txtPhone.Text, txtPhoneExt.Text, User.Identity.Name);
                    //End code to overcome issue with Membership.CreateUser
                    T_OE_USERS u = db_Accounts.GetT_OE_USERSByID(txtUserID.Text);

                    if (u != null)
                        SuccID = db_Accounts.UpdateT_OE_USERS(u.USER_IDX, null, null, txtFName.Text, txtLName.Text, txtEmail.Text, true, false, System.DateTime.Now, null, txtPhone.Text, txtPhoneExt.Text, User.Identity.Name);
                    else
                        SuccID = 0;
                }

                if (SuccID > 0)
                {
                    lblMsg.Text = "User updated successfully.";
                    lblMsg.ForeColor = System.Drawing.Color.Black;
                    PopulateForm(SuccID);
                }
                else
                {
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                    lblMsg.Text = "Error updating user. <br>" + lblMsg.Text;
                }    
            }
            catch (Exception exp)
            {
                Console.WriteLine(exp);
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                if (db_Accounts.DeleteT_OE_USERS(int.Parse(Session["UserEditID"].ToString())) == 1)  //user deletion successful 
                    Response.Redirect("~/Account/UserList.aspx");
                else
                    lblMsg.Text = "Error deleting user.";
            }
            catch (Exception exp)
            {
                Console.WriteLine(exp);
            }
        }
        public string GetErrorMessage(MembershipCreateStatus status)
        {
            switch (status)
            {
                case MembershipCreateStatus.DuplicateUserName:
                    return "Username already exists. Please enter a different user name.";

                case MembershipCreateStatus.DuplicateEmail:
                    return "A username for that e-mail address already exists. Please enter a different e-mail address.";

                case MembershipCreateStatus.InvalidPassword:
                    return "The password provided is invalid. Please enter a valid password value.";

                case MembershipCreateStatus.InvalidEmail:
                    return "The e-mail address provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidAnswer:
                    return "The password retrieval answer provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidQuestion:
                    return "The password retrieval question provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidUserName:
                    return "The user name provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.ProviderError:
                    return "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                case MembershipCreateStatus.UserRejected:
                    return "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                default:
                    return "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.";
            }
        }
        private string GenerateSalt()
        {
            byte[] buf = new byte[32];
            (new System.Security.Cryptography.RNGCryptoServiceProvider()).GetBytes(buf);
            return Convert.ToBase64String(buf);
        }

        private string HashPassword(string pass, string salt)
        {
                System.Security.Cryptography.SHA256Managed hash = new System.Security.Cryptography.SHA256Managed();
                byte[] utf8 = System.Text.UTF8Encoding.UTF8.GetBytes(pass + salt);
                System.Text.StringBuilder s = new System.Text.StringBuilder(hash.ComputeHash(utf8).Length * 2);
                foreach (byte b in hash.ComputeHash(utf8))
                    s.Append(b.ToString("x2"));
                return s.ToString();
            
        }
    }

}