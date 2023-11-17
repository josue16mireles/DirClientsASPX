using DevExpress.Web;
using dir_clients.Classes;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.String;

namespace dir_clients
{
    public partial class NewCpyProd : System.Web.UI.UserControl
    {
        public bool Ccon { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void esmdCpy_prod_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.QueryableSource = DBFunciones.IContext.vcpy_prod.AsQueryable();
            e.KeyExpression = "uid_company";
            e.DefaultSorting = "company";
        }

        //protected void esmdCpy_prod_Inserting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        //{

        //}

        //protected void esmdCpy_prod_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        //{

        //}
        protected void GridView_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == esmdCpy_prod.ID)
                x.CancelEdit();
        }

        protected void GridView_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == esmdCpy_prod.ID)
                x.CancelEdit();
        }

        protected void GridView_CustomErrorText(object sender, ASPxGridViewCustomErrorTextEventArgs e)
        {
            switch (e.Exception)
            {
                case NullReferenceException _:
                    e.ErrorText = "NullReferenceExceptionText";
                    break;
                case InvalidOperationException _:
                    e.ErrorText = "InvalidOperationExceptionText";
                    break;
                default:
                    var x = e.Exception.GetBaseException();
                    var i = IsNullOrEmpty(x.Message) ? e.Exception.Message : x.Message;
                    var index = i.IndexOf("\r", StringComparison.Ordinal);
                    if (index > 0)
                        e.ErrorText = i.Substring(0, index);
                    break;
            }
        }

        protected void ASPxRoundPanel1_Init(object sender, EventArgs e)
        {
            var ini = (ASPxRoundPanel)sender;
            ini.ShowHeader = false;
            ini.View = DevExpress.Web.View.GroupBox;
        }

        protected void GridView_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            Ccon = true;
            GridView.DataBind();
        }
    }
}