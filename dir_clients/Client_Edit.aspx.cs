using ClientsDataModel;
using DevExpress.Web;
using dir_clients.Classes;
using System;
using System.Data;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Linq;
using System.Net.Sockets;
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
            var id = (Guid)e.Keys[cvClientEdit.KeyFieldName];

            var i = DBFunciones.IContext.vclients.Find(id);
            if (i != null) 
            {
                i.nombre = (string)e.Values["nombre"];
                i.direccion = (string)e.Values["direccion"];
                i.telefono = (string)e.Values["telefono"];
                i.celular = (string)e.Values["celular"];
                i.email = (string)e.Values["email"];
                i.email2 = (string)e.Values["email2"];
                i.relacionado = (string)e.Values["relacionado"];
                i.archivero = (string)e.Values["archivero"];
                DBFunciones.IContext.SaveChanges();
            }
            e.Handled = true;
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
        protected void grid_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            //ASPxGridView gridView = sender as ASPxGridView;
            //if (e.Column.FieldName == "uid_prodpol")
            //{
            //    ASPxComboBox cmbCity = (e.Editor as ASPxComboBox);
            //    cmbCity.Callback += cmbProdpol_OnCallback;
            //}
            if (e.Column.FieldName == "uid_prodpol")
            {
                var combo = (ASPxComboBox)e.Editor;
                combo.Callback += new CallbackEventHandlerBase(combo_Callback);

                var grid = e.Column.Grid;
                if (!combo.IsCallback)
                {
                    var UIDCpy = -1;
                    if (!grid.IsNewRowEditing)
                        UIDCpy = (int)grid.GetRowValues(e.VisibleIndex, "company");
                    FillCitiesComboBox(combo, UIDCpy);
                }
            }
        }
        private void combo_Callback(object sender, CallbackEventArgsBase e)
        {
            var UIDCpy = -1;
            Int32.TryParse(e.Parameter, out UIDCpy);
            FillCitiesComboBox(sender as ASPxComboBox, UIDCpy);
        }

        protected void FillCitiesComboBox(ASPxComboBox combo, int UIDCpy)
        {
            combo.DataSourceID = "dsProdPol";
            dsProdPol.SelectParameters["company"].DefaultValue = UIDCpy.ToString();
            combo.DataBindItems();

            combo.Items.Insert(0, new ListEditItem("", null)); // Null Item
        }
        //protected void FillProdpolCombo(ASPxComboBox cmb, string cpy)
        //{
        //    cmb.DataSourceID = null;
        //    cmb.Items.Clear();

        //    if (!string.IsNullOrEmpty(cpy))
        //    {
        //        //cmb.DataSource = WorldCitiesDataProvider.GetCities(Convert.ToInt32(country));
        //        cmb.DataSource = dsProdPol.ID;
        //        cmb.DataBindItems();
        //    }
        //}
        //void cmbProdpol_OnCallback(object source, CallbackEventArgsBase e)
        //{
        //    FillProdpolCombo(source as ASPxComboBox, e.Parameter);
        //}

        protected void esmdPolizasClient_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {//selecting gridview
            e.QueryableSource = DBFunciones.IContext.vpolizas.Where(a => a.uid_client == SessionMov).AsQueryable();
            //e.QueryableSource = DBFunciones.IContext.vpolizas.Where(a => a.uid_client == SessionMov && a.estatus == 1).AsQueryable();
            //e.DefaultSorting = "NoPartida";
            e.KeyExpression = "uid_poliza";
        }
        protected void esmdPolizasClient_Inserting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {//inserting gridview
            try
            {
                if (IsNullOrEmpty((string)e.Values["no_poliza"]))
                    throw new Exception("Ingrese un número de poliza en el campo.");
                if ((DateTime)e.Values["fech_inicio"] == null)
                    throw new Exception("Seleccione una fecha de inicio en el calendario.");
                if (IsNullOrEmpty((string)e.Values["tipo_pago"]))
                    throw new Exception("Seleccione la frecuencia de pago en la lista.");
                //if ((Guid?)e.Values["uid_prodpol"] == null)
                //    throw new Exception("Seleccione un producto de la lista.");
                //if ((Guid?)e.Values["uid_company"] == null)
                //    throw new Exception("Seleccione una compañia de la lista.");

                var i = new vpoliza
                {
                    uid_poliza = Guid.NewGuid(),
                    uid_client = SessionMov,
                    no_poliza = (string)e.Values["no_poliza"],
                    fech_inicio = (DateTime)e.Values["fech_inicio"],
                    uid_prodpol = (Guid)e.Values["uid_prodpol"],
                    tipo_pago = (string)e.Values["tipo_pago"],
                    uid_company = (Guid)e.Values["uid_company"],
                };
                DBFunciones.IContext.vpolizas.Add(i);
                DBFunciones.IContext.SaveChanges();
                e.Handled = true;
                DBFunciones.IContext = null;
            }
            catch (DbEntityValidationException x)
            {
                foreach (var eve in x.EntityValidationErrors)
                {
                    Console.WriteLine(@"La entidad de tipo ""{0}"" en el estado ""{1}"" tiene los siguientes errores de validación:",
                        eve.Entry.Entity.GetType().Name, eve.Entry.State);
                    foreach (var ve in eve.ValidationErrors)
                        Console.WriteLine(@"La entidad de tipo ""{0}"" en el estado ""{1}"" tiene los siguientes errores de validación:",
                            ve.PropertyName, ve.ErrorMessage);
                }
                throw;
            }
        }
        protected void esmdPolizasClient_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {//updating gridview
            try
            {
                var id = (Guid)e.Keys[GridView.KeyFieldName];

                if (IsNullOrEmpty((string)e.Values["no_poliza"]))
                    throw new Exception("Ingrese un número de poliza en el campo.");
                if ((DateTime)e.Values["fech_inicio"] == null)
                    throw new Exception("Seleccione una fecha de inicio en el calendario.");
                if (IsNullOrEmpty((string)e.Values["tipo_pago"]))
                    throw new Exception("Seleccione la frecuencia de pago en la lista.");
                //if ((Guid?)e.Values["uid_prodpol"] == null)
                //    throw new Exception("Seleccione un producto de la lista.");
                //if ((Guid?)e.Values["uid_company"] == null)
                //    throw new Exception("Seleccione una compañia de la lista.");

                var i = DBFunciones.IContext.vpolizas.Find(id);
                if(i != null)
                {
                    i.no_poliza = (string)e.Values["no_poliza"];
                    i.fech_inicio = (DateTime)e.Values["fech_inicio"];
                    i.uid_prodpol = (Guid)e.Values["uid_prodpol"];
                    i.tipo_pago = (string)e.Values["tipo_pago"];
                    i.uid_company = (Guid)e.Values["uid_company"];
                    DBFunciones.IContext.SaveChanges();
                }
                e.Handled= true;
            }
            catch (DbEntityValidationException x)
            {
                foreach (var eve in x.EntityValidationErrors)
                {
                    Console.WriteLine(@"La entidad de tipo ""{0}"" en el estado ""{1}"" tiene los siguientes errores de validación:",
                        eve.Entry.Entity.GetType().Name, eve.Entry.State);
                    foreach (var ve in eve.ValidationErrors)
                        Console.WriteLine(@"La entidad de tipo ""{0}"" en el estado ""{1}"" tiene los siguientes errores de validación:",
                            ve.PropertyName, ve.ErrorMessage);
                }
                throw;
            }
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

        protected void GridView_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == ColumnCommandButtonType.Update || e.ButtonType == ColumnCommandButtonType.Cancel || e.ButtonType == ColumnCommandButtonType.PreviewChanges)
                e.Visible = false;
        }

        //protected void dsCpyDataSource_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        //{
        //    DBFunciones.IsGuid(GridView?.GetRowValues(GridView?.FocusedRowIndex ?? 0, "uid_company")?.ToString(), out Guid UIDCpy);

        //    e.QueryableSource = DBFunciones.IContext.vcompanies.Where(a => a.uid_company == UIDCpy).ToList().AsQueryable();
        //    e.KeyExpression = "uid_company";
        //}

        //protected void dsProdPol_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        //{
        //    DBFunciones.IsGuid(GridView?.GetRowValues(GridView?.FocusedRowIndex ?? 0, "uid_prodpol")?.ToString(), out Guid UIDProdpol);

        //    e.QueryableSource = DBFunciones.IContext.vprodpols.Where(a => a.uid_prodpol == UIDProdpol).ToList().AsQueryable();
        //    e.KeyExpression = "uid_prodpol";
        //}
    }
}