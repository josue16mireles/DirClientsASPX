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
using DevExpress.Web.Internal.XmlProcessor;
using ClientsDataModel.test;

namespace dir_clients
{
    public partial class Polizas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void dsPlizas_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.QueryableSource = DBFunciones.IContext.vpolizas.AsQueryable();
            e.KeyExpression = "uid_poliza";
        }

        protected void dsPlizas_Inserting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {

        }

        protected void dsPlizas_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {

        }

        protected void dsPlizas_Deleting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {

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
            if (GridView.IsEditing && e.Column.FieldName == "uid_prod_pol")
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
            //cmb.DataSource = "dsProdPol"; //WorldCitiesDataProvider.GetCities(Convert.ToInt32(cpy));
            cmb.DataBindItems();
        }
        void cmbProdPol_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillProdpolCombo(source as ASPxComboBox, e.Parameter);
        }
        string lastValidCpy = null;
        bool hasValidationErrors = false;
    }
}
