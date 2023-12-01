using DevExpress.Web.Data;
using DevExpress.Web;
using dir_clients.Classes;
using ClientsDataModel;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.String;
using System.Data.Entity.Validation;

namespace dir_clients
{
    public partial class Polizas : System.Web.UI.Page
    {
        public int FiLoad { get; set; }
        private vpoliza _Getform;
        public vpoliza Getform
        {
            set => Session["_vpoliza"] = value;
            get
            {
                if (Session["_vpoliza"] == null) GridView.DataBind();
                _Getform = (vpoliza)Session["_vpoliza"];
                return _Getform;
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
            if (!Page.IsPostBack)
            {
                Session["uidmov"] = null;
                //Session["CurrentPage"] = "Clientes";
                GridView.DataBind();
            }
        }

        protected void dsPolizas_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.QueryableSource = DBFunciones.IContext.vpolizas.AsQueryable();
            e.KeyExpression = "uid_poliza";
        }

        protected void dsPolizas_Inserting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                if (IsNullOrEmpty((string)e.Values["no_poliza"]))
                    throw new Exception("Ingrese un número de poliza en el campo.");
                if ((DateTime)e.Values["fech_inicio"] == null)
                    throw new Exception("Seleccione una fecha de inicio en el calendario.");
                if (IsNullOrEmpty((string)e.Values["tipo_pago"]))
                    throw new Exception("Seleccione la frecuencia de pago en la lista.");
                //if ((Guid)e.Values["uid_prodpol"] == null)
                if (IsNullOrEmpty((string)e.Values["uid_prodpol"]))
                    throw new Exception("Seleccione un producto de la lista.");
                if (IsNullOrEmpty((string)e.Values["uid_company"]))
                    throw new Exception("Seleccione una compañia de la lista.");

                var i = new vpoliza
                {
                    uid_poliza = Guid.NewGuid(),
                    uid_client = (Guid)e.Values["uid_client"],
                    no_poliza = (string)e.Values["no_poliza"],
                    fech_inicio = (DateTime)e.Values["fech_inicio"],
                    uid_prodpol = (string)e.Values["uid_prodpol"],
                    tipo_pago = (string)e.Values["tipo_pago"],
                    uid_company = (string)e.Values["uid_company"],
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

        protected void dsPolizas_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
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
                if (IsNullOrEmpty((string)e.Values["uid_prodpol"]))
                    throw new Exception("Seleccione un producto de la lista.");
                if (IsNullOrEmpty((string)e.Values["uid_company"]))
                    throw new Exception("Seleccione una compañia de la lista.");

                var i = DBFunciones.IContext.vpolizas.Find(id);
                if (i != null)
                {
                    i.uid_client = (Guid)e.Values["uid_client"];
                    i.no_poliza = (string)e.Values["no_poliza"];
                    i.fech_inicio = (DateTime)e.Values["fech_inicio"];
                    i.tipo_pago = (string)e.Values["tipo_pago"];
                    i.uid_company = (string)e.Values["uid_company"];
                    i.uid_prodpol = (string)e.Values["uid_prodpol"];
                    DBFunciones.IContext.SaveChanges();
                }
                e.Handled = true;
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

        protected void GridView_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == dsPolizas.ID)
                x.CancelEdit();
        }
        protected void GridView_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == dsPolizas.ID)
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
        protected void cbpage_Callback(object source, CallbackEventArgs e)
        {
            string[] _aux = e.Parameter.Split('|');
            var _switch = _aux[0]?.ToString();
            try
            {
                switch (_switch)
                {
                    case "Editar":
                        if (string.IsNullOrWhiteSpace(_aux[1])) throw new Exception("No se pudo localizar el cliente");
                        Session["uidmov"] = Guid.Parse(_aux[1]);
                        break;
                }
                e.Result = _switch;
            }
            catch (Exception ex)
            {
                e.Result = "Error|" + ex.Message;
            }
        }
        protected void GridView_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            ASPxGridView gridView = sender as ASPxGridView;
            if (e.Column.FieldName == "uid_prodpol")
            {
                ASPxComboBox cmbProd = (e.Editor as ASPxComboBox);
                cmbProd.Callback += cmbProd_OnCallback;
            }
        }
        protected void FillProdCombo(ASPxComboBox cmb, string cpy)
        {
            cmb.DataSourceID = null;
            cmb.Items.Clear();

            if (!string.IsNullOrEmpty(cpy))
            {
                cmb.DataSource = DBFunciones.IContext.vprodpols.Where(i => i.uid_company == cpy).AsQueryable().ToList();
                cmb.DataBindItems();
            }
        }
        void cmbProd_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillProdCombo(source as ASPxComboBox, e.Parameter);
        }

        //protected void Page_Init(object sender, EventArgs e)
        //{
        //    if (Session["baseURL"] == null)
        //        Session["baseURL"] = "Client_Edit.aspx";
        //}

        //protected void linkclient_Init(object sender, EventArgs e)
        //{
        //    ASPxHyperLink link = (ASPxHyperLink)sender;

        //    GridViewDataItemTemplateContainer templateContainer = (GridViewDataItemTemplateContainer)link.NamingContainer;
        //    int rowVisibleIndex = templateContainer.VisibleIndex;
        //    string ean13 = templateContainer.Grid.GetRowValues(rowVisibleIndex, "nombre").ToString();
        //    //string contentUrl = string.Format("{0}?uid_client={1}", Session["baseURL"], ean13);
        //    link.NavigateUrl = "javascript:edicion();";
        //    link.Text = string.Format("{0}", ean13);
        //    //link.ClientSideEvents.Click = string.Format("function(s, e) {{ OnMoreInfoClick('{0}'); }}", contentUrl);
        //}
    }
}
