using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OpenEnvironment.App_Logic.DataAccessLayer
{
    public class db_Config
    {
        public static List<T_OE_COLUMNCONFIG> GetT_OE_COLUMNCONFIG()
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_COLUMNCONFIG
                            select a).ToList();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        //TODO: Change Saved_Column_Config column name for don't send_to_WQX to be send_to_WQX
        public static int InsertT_OE_SAVED_COLUMN_CONFIG(global::System.String configName, global::System.String orgID, global::System.Int32 wqxColID, global::System.String userColName)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    T_OE_SAVED_COLUMN_CONFIG a = new T_OE_SAVED_COLUMN_CONFIG();

                    a.CONFIG_NAME = configName;
                    a.ORG_ID = orgID;
                    a.WQX_COL_ID = wqxColID;
                    a.USER_COL_NAME = userColName;

                    ctx.AddToT_OE_SAVED_COLUMN_CONFIG(a);
                    ctx.SaveChanges();
                    return 1;
                }
                catch (Exception ex)
                {
                    throw ex;
                    return 0;
                }
            }
        }

        public static List<T_OE_SAVED_COLUMN_CONFIG> GetT_OE_SAVED_COLUMN_CONFIG_TEMPLATE()
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_SAVED_COLUMN_CONFIG
                            group a by a.CONFIG_NAME into uniqueName
                            select uniqueName.FirstOrDefault()).ToList();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static List<T_OE_SAVED_COLUMN_CONFIG> GetT_OE_SAVED_COLUMN_CONFIG(string orgID, string configName)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_SAVED_COLUMN_CONFIG
                            where a.ORG_ID == orgID && a.CONFIG_NAME == configName
                            select a).ToList();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static string GetT_OE_COLUMNCONFIG_Name(int wqxColID)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_COLUMNCONFIG
                            where a.COLUMNCONFIG_IDX == wqxColID
                            select a).FirstOrDefault().COLUMN_NAME;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static int GetT_OE_COLUMNCONFIG_ID(string cOLUMN_NAME)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_COLUMNCONFIG
                            where a.COLUMN_NAME == cOLUMN_NAME
                            select a).FirstOrDefault().COLUMNCONFIG_IDX;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static int GetT_OE_COLUMNCONFIG_ID(string uSER_COLUMN_NAME, string orgID, string configName)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_SAVED_COLUMN_CONFIG
                            where a.USER_COL_NAME == uSER_COLUMN_NAME && a.ORG_ID == orgID && a.CONFIG_NAME == configName
                            select a).FirstOrDefault().WQX_COL_ID.GetValueOrDefault();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        //TODO: add parameters for both org ID and template name.
        public static string GetT_OE_SAVED_COLUMN_CONFIG_Name(int wqxColID)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_SAVED_COLUMN_CONFIG
                            where a.WQX_COL_ID == wqxColID
                            select a).FirstOrDefault().USER_COL_NAME;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static string GetT_OE_COLUMNCONFIG_Unit(int cOLUMNCONFIG_IDX)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_COLUMNCONFIG
                            where a.COLUMNCONFIG_IDX == cOLUMNCONFIG_IDX
                            select a).FirstOrDefault().UNIT;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static bool GetT_OE_COLUMNCONFIG_SEND_TO_WQX(string wQXColumnName)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_COLUMNCONFIG
                            where a.COLUMN_NAME == wQXColumnName
                            select a).FirstOrDefault().COLUMN_DONT_SEND.GetValueOrDefault();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static T_OE_COLUMNCONFIG GetT_OE_COLUMNCONFIG_VALUE(int cOLUMNCONFIG_IDX)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_COLUMNCONFIG
                            where a.COLUMNCONFIG_IDX == cOLUMNCONFIG_IDX
                            select a).FirstOrDefault();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static int GetT_OE_SAVED_COLUMN_CONFIG_WQXID(string orgID, string configName, string userColumnName)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_SAVED_COLUMN_CONFIG
                            where a.ORG_ID == orgID && a.CONFIG_NAME == configName && a.USER_COL_NAME == userColumnName
                            select a).FirstOrDefault().WQX_COL_ID.GetValueOrDefault();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            } 
        
        }

        public static int DeleteT_OE_ColumnConfig(int columnConfig_IDX)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    T_OE_COLUMNCONFIG r = new T_OE_COLUMNCONFIG();
                    r = (from c in ctx.T_OE_COLUMNCONFIG where c.COLUMNCONFIG_IDX == columnConfig_IDX select c).FirstOrDefault();
                    ctx.DeleteObject(r);
                    ctx.SaveChanges();
                    return 1;
                }
                catch
                {
                    return 0;
                }
            }

        }

        public static int InsertOrUpdateT_OE_ColumnConfig(global::System.Int32? cOLUMNCONFIG_IDX, global::System.String cOLUMN_NAME,
           global::System.String uNIT, global::System.Double mAXVALUE, global::System.Double mINVALUE,
           global::System.Boolean cOLUMNDONTSEND)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                Boolean insInd = false;
                try
                {
                    T_OE_COLUMNCONFIG a = new T_OE_COLUMNCONFIG();

                    if (cOLUMNCONFIG_IDX != null)
                        a = (from c in ctx.T_OE_COLUMNCONFIG
                             where c.COLUMNCONFIG_IDX == cOLUMNCONFIG_IDX
                             select c).FirstOrDefault();

                    if (cOLUMNCONFIG_IDX == null) //insert case
                    {
                        a = new T_OE_COLUMNCONFIG();
                        insInd = true;
                    }

                    if (cOLUMN_NAME != null) a.COLUMN_NAME = cOLUMN_NAME;
                    if (uNIT != null) a.UNIT = uNIT;
                    a.MAX_VALUE = mAXVALUE;
                    a.MIN_VALUE = mINVALUE;
                    a.COLUMN_DONT_SEND = cOLUMNDONTSEND;

                    if (insInd) //insert case
                    {
                        //    a.CREATE_USERID = cREATE_USER.ToUpper();
                        //    a.CREATE_DT = System.DateTime.Now;
                        ctx.AddToT_OE_COLUMNCONFIG(a);
                    }
                    else
                    {
                        //    a.UPDATE_USERID = cREATE_USER.ToUpper();
                        //    a.UPDATE_DT = System.DateTime.Now;
                    }

                    ctx.SaveChanges();

                    return a.COLUMNCONFIG_IDX;
                }
                catch (Exception ex)
                {
                    return 0;
                }
            }
        }

        // *************************** Analyze Config *********************************
        // *********************************************************************
        public static List<T_OE_ANALYZECONFIG> GetT_OE_AnalyzeConfig(string OrgID, int UserID)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_ANALYZECONFIG
                            where a.ORG_ID == OrgID
                            && a.USER_IDX == UserID
                            orderby a.ANALYZECONFIG_NAME
                            select a).ToList();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        public static T_OE_ANALYZECONFIG GetT_OE_AnalyzeConfig_ByID(int aNALYZECONFIG_IDX)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    return (from a in ctx.T_OE_ANALYZECONFIG
                            where a.ANALYZECONFIG_IDX == aNALYZECONFIG_IDX
                            select a).FirstOrDefault();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }



        public static int DeleteT_OE_AnalyzeConfig(int AnalyzeConfig_IDX)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                try
                {
                    T_OE_ANALYZECONFIG r = new T_OE_ANALYZECONFIG();
                    r = (from c in ctx.T_OE_ANALYZECONFIG where c.ANALYZECONFIG_IDX == AnalyzeConfig_IDX select c).FirstOrDefault();
                    ctx.DeleteObject(r);
                    ctx.SaveChanges();
                    return 1;
                }
                catch
                {
                    return 0;
                }
            }

        }


        public static int InsertOrUpdateT_OE_AnalyzeConfig(global::System.Int32? aNALYZECONFIG_IDX, global::System.String oRG_ID, global::System.String aNALYZECONFIG_NAME, 
            global::System.Int32 uSER_IDX, global::System.String sITES, global::System.String cHARACTERISTIC, global::System.DateTime sTART_DATE, 
            global::System.DateTime eND_DATE, global::System.Double uPPER_THRESHOLD, global::System.Double lOWER_THRESHOLD)
        {
            using (OpenEnvironmentEntities ctx = new OpenEnvironmentEntities())
            {
                Boolean insInd = false;
                try
                {
                    T_OE_ANALYZECONFIG a = new T_OE_ANALYZECONFIG();

                    if (aNALYZECONFIG_IDX != null)
                        a = (from c in ctx.T_OE_ANALYZECONFIG
                             where c.ANALYZECONFIG_IDX == aNALYZECONFIG_IDX
                             select c).FirstOrDefault();

                    if (aNALYZECONFIG_IDX == null) //insert case
                    {
                        a = new T_OE_ANALYZECONFIG();
                        insInd = true;
                    }

                    if (oRG_ID != null) a.ORG_ID = oRG_ID;
                    if (aNALYZECONFIG_NAME != null) a.ANALYZECONFIG_NAME = aNALYZECONFIG_NAME;
                    if (uSER_IDX != null) a.USER_IDX = uSER_IDX;
                    if (sITES != null) a.SITES = sITES;
                    if (cHARACTERISTIC != null) a.CHARACTERISTIC = cHARACTERISTIC;
                    if (sTART_DATE != null) a.START_DATE = sTART_DATE;
                    if (eND_DATE != null) a.END_DATE = eND_DATE;
                    if (uPPER_THRESHOLD != null) a.UPPER_THRESHOLD = uPPER_THRESHOLD;
                    if (lOWER_THRESHOLD != null) a.LOWER_THRESHOLD = lOWER_THRESHOLD;

                    if (insInd) //insert case
                    {
                    //    a.CREATE_USERID = cREATE_USER.ToUpper();
                    //    a.CREATE_DT = System.DateTime.Now;
                        ctx.AddToT_OE_ANALYZECONFIG(a);
                    }
                    else
                    {
                    //    a.UPDATE_USERID = cREATE_USER.ToUpper();
                    //    a.UPDATE_DT = System.DateTime.Now;
                    }

                    ctx.SaveChanges();

                    return a.ANALYZECONFIG_IDX;
                }
                catch (Exception ex)
                {
                    return 0;
                }
            }
        }

        
    }
}