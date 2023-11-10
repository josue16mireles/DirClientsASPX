using DevExpress.Web.Data;
using DevExpress.Web;
using dir_clients.Classes;
using ClientsDataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.String;
using System.Data.Entity.Validation;

namespace dir_clients
{
    public partial class Polizas : System.Web.UI.Page
    {
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
                //if (IsNullOrEmpty((string)e.Values["no_poliza"]))
                //    throw new Exception("Ingrese un número de poliza en el campo.");
                //if ((DateTime)e.Values["fech_inicio"] == null)
                //    throw new Exception("Seleccione una fecha de inicio en el calendario.");
                //if (IsNullOrEmpty((string)e.Values["tipo_pago"]))
                //    throw new Exception("Seleccione la frecuencia de pago en la lista.");
                //if ((Guid?)e.Values["uid_prodpol"] == null)
                //    throw new Exception("Seleccione un producto de la lista.");
                //if ((Guid?)e.Values["uid_company"] == null)
                //    throw new Exception("Seleccione una compañia de la lista.");

                var i = new vpoliza
                {
                    uid_poliza = Guid.NewGuid(),
                    uid_client = (Guid)e.Values["uid_client"],
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

        protected void dsPolizas_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                var id = (Guid)e.Keys[GridView.KeyFieldName];

                //if (IsNullOrEmpty((string)e.Values["no_poliza"]))
                //    throw new Exception("Ingrese un número de poliza en el campo.");
                //if ((DateTime)e.Values["fech_inicio"] == null)
                //    throw new Exception("Seleccione una fecha de inicio en el calendario.");
                //if (IsNullOrEmpty((string)e.Values["tipo_pago"]))
                //    throw new Exception("Seleccione la frecuencia de pago en la lista.");
                //if ((Guid?)e.Values["uid_prodpol"] == null)
                //    throw new Exception("Seleccione un producto de la lista.");
                //if ((Guid?)e.Values["uid_company"] == null)
                //    throw new Exception("Seleccione una compañia de la lista.");

                var i = DBFunciones.IContext.vpolizas.Find(id);
                if (i != null)
                {
                    i.uid_client = (Guid)e.Values["uid_client"];
                    i.no_poliza = (string)e.Values["no_poliza"];
                    i.fech_inicio = (DateTime)e.Values["fech_inicio"];
                    i.uid_prodpol = (Guid)e.Values["uid_prodpol"];
                    i.tipo_pago = (string)e.Values["tipo_pago"];
                    i.uid_company = (Guid)e.Values["uid_company"];
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
        protected void GridView_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
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

        protected void prodpol_ItemRequestedByValue(object source, ListEditItemRequestedByValueEventArgs e)
        {
            if (string.IsNullOrEmpty(e.Value?.ToString())) return;
            var comboBox = (ASPxComboBox)source;
            if (comboBox == null) return;

            DBFunciones.IsGuid(e.Value?.ToString(), out var x);
            var cntxt = new ModelClients();
            var i = from vcompany in cntxt.vcompanies
                    where vcompany.uid_company == x
                    select vcompany;
            comboBox.DataSource = i.ToList();
            comboBox.DataBind();
        }

        protected void prodpol_ItemsRequestedByFilterCondition(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            if (string.IsNullOrEmpty(e.Filter)) return;
            var comboBox = (ASPxComboBox)source;
            if (comboBox == null) return;
            var skip = e.BeginIndex;
            var take = e.EndIndex - e.BeginIndex + 1;
            var cntxt = new ModelClients();
            var i = (from vcompany in cntxt.vcompanies
                     where vcompany.company .Contains(e.Filter)
                     orderby vcompany.company
                     select vcompany).Skip(skip).Take(take).ToList();
            comboBox.DataSource = i;
            comboBox.DataBind();
        }

        protected void GridView_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            ASPxGridView GridView = sender as ASPxGridView;
            if (GridView.IsEditing && e.Column.FieldName == "uid_prodpol")
            {
                ASPxComboBox comboboxProdpol = e.Editor as ASPxComboBox;
                comboboxProdpol.Callback += cmbProdPol_OnCallback;
                var currentCpy = GridView.GetRowValues(e.VisibleIndex, "uid_company");
                if (hasValidationErrors)
                    FillProdpolCombo(comboboxProdpol, lastValidCpy);
                else
                    if (e.KeyValue != DBNull.Value && e.KeyValue != null && currentCpy != null && currentCpy != DBNull.Value)
                {
                    FillProdpolCombo(comboboxProdpol, currentCpy.ToString());
                }
                else
                {
                    comboboxProdpol.DataSourceID = null;//"dsCpy"; // dsProdPol
                    comboboxProdpol.Items.Clear();
                }
            }
        }
        protected void FillProdpolCombo(ASPxComboBox cmb, string cpy)
        {
            if (string.IsNullOrEmpty(cpy)) return;

            cmb.DataSourceID = null;
            cmb.DataSource = dsProdPol.ID; //WorldCitiesDataProvider.GetCities(Convert.ToInt32(cpy));
            cmb.DataBindItems();
        }
        void cmbProdPol_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillProdpolCombo(source as ASPxComboBox, e.Parameter);
        }
        string lastValidCpy = null;
        bool hasValidationErrors = false;
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
    }
}
