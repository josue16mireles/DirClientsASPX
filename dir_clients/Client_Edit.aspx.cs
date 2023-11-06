using ClientsDataModel;
using DevExpress.Web;
using dir_clients.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.String;

namespace dir_clients
{
    public partial class Client_Edit : Page
    {
        private vclient _Getform;
        public vclient Getform
        {
            set => Session["_vclient"] = value;
            get
            {
                if (Session["_vclient"] == null) cvClientEdit.DataBind();
                _Getform = (vclient)Session["_vclient"];
                return _Getform;
            }
        }
        private Guid _uidmovs;
        public Guid UIDMOVS
        {
            set => Session["uidmov"] = value;
            get
            {
                if (Session["uidmov"] == null) Response.Redirect("~/");
                if ((Guid)Session["uidmov"] == Guid.Empty) Response.Redirect("~/");
                _uidmovs = (Guid)Session["uidmov"];
                return _uidmovs;
            }
        }
        public Guid SessionMov
        {
            get
            {
                DBFunciones.IsGuid(Getform.uid_client.ToString(), out var x);
                Session["UIDMOVS"] = x;
                return x;
            }

        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void esmdClient_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {//selecting cardview
            Getform = DBFunciones.IContext.vclients.Find(UIDMOVS);
            List<vclient> listclient = new List<vclient>{Getform};
            e.QueryableSource = listclient.AsQueryable();
            e.KeyExpression = "uid_client";
        }

        protected void esmdClient_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {//updating cardview

        }

        protected void cvClientEdit_CardUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            var x = (ASPxCardView)sender;
            if (x != null && x.DataSourceID == esmdClient.ID)
                x.CancelEdit();
        }

        protected void cvClientEdit_CustomErrorText(object sender, DevExpress.Web.ASPxCardViewCustomErrorTextEventArgs e)
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

        protected void esmdPolizasClient_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {//selecting gridview
            e.QueryableSource = DBFunciones.IContext.vpolizas.Where(a => a.uid_client == SessionMov).AsQueryable();
            //e.DefaultSorting = "NoPartida";
            e.KeyExpression = "uid_poliza";
        }
        protected void esmdPolizasClient_Inserting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {//inserting gridview

        }
        protected void esmdPolizasClient_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {//updating gridview

        }

        protected void GridView_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            GridView.DataBind();
        }

        protected void GridView_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == esmdPolizasClient.ID)
                x.CancelEdit();
        }

        protected void GridView_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == esmdPolizasClient.ID)
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
    }
}