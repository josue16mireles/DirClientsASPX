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
using DevExpress.XtraRichEdit.Layout;
using System.Collections.Generic;
using System.Data.Entity;
using System.Web.Services.Description;
using static DevExpress.Utils.Svg.CommonSvgImages;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;

namespace dir_clients
{
    public partial class Polizas : System.Web.UI.Page
    {
        private vpoliza _Getform;
        public vpoliza Getform
        {
            set => Session["_vpoliza"] = value;
            get
            {
                if (Session["_vpoliza"] == null) gvPolizas.DataBind();
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
            gvPolizas.FilterExpression = "[estatus] = 'activa'";
            gvPolizas.DataBind();
            if (!Page.IsPostBack)
            {
                Session["uidmov"] = null;

                var colAno = gvPolizas.Columns["ano"] as GridViewDataComboBoxColumn;
                if (colAno != null)
                {
                    // Agrega una opción vacía al principio
                    colAno.PropertiesComboBox.Items.Add(" ", null);  // texto visible: " ", valor: null

                    for (int year = DateTime.Now.Year + 1; year >= 1950; year--)
                    {
                        colAno.PropertiesComboBox.Items.Add(year.ToString(), year);
                    }

                    colAno.PropertiesComboBox.ValueType = typeof(short);  // Asegura que acepte valores short o null
                }
            }

            if (IsPostBack && Request["__EVENTTARGET"] == "ExportToPdf")
            {
                ExportGridToPdf();
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
                DBFunciones.IContext = null;
                if (IsNullOrEmpty((string)e.Values["no_poliza"]))
                    throw new Exception("Ingrese un número de poliza en el campo.");
                if ((DateTime)e.Values["fech_inicio"] == null)
                    throw new Exception("Seleccione una fecha de inicio en el calendario.");
                if (IsNullOrEmpty((string)e.Values["tipo_pago"]))
                    throw new Exception("Seleccione la frecuencia de pago en la lista.");
                if (IsNullOrEmpty((string)e.Values["uid_product"]))
                    throw new Exception("Seleccione un producto de la lista.");
                if (IsNullOrEmpty((string)e.Values["uid_company"]))
                    throw new Exception("Seleccione una compañia de la lista.");

                var i = new vpoliza
                {
                    uid_poliza = Guid.NewGuid(),
                    uid_client = (Guid)e.Values["uid_client"],
                    no_poliza = (string)e.Values["no_poliza"],
                    serie = ((string)e.Values["serie"])?.ToUpper(),
                    ano = e.Values["ano"] != null && e.Values["ano"].ToString() != "" ? (short?)Convert.ToInt16(e.Values["ano"]) : null,
                    fech_inicio = (DateTime)e.Values["fech_inicio"],
                    uid_product = (string)e.Values["uid_product"],
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
                DBFunciones.IContext = null;
                var id = (Guid)e.Keys[gvPolizas.KeyFieldName];

                if (IsNullOrEmpty((string)e.Values["no_poliza"]))
                    throw new Exception("Ingrese un número de poliza en el campo.");
                if ((DateTime)e.Values["fech_inicio"] == null)
                    throw new Exception("Seleccione una fecha de inicio en el calendario.");
                if (IsNullOrEmpty((string)e.Values["tipo_pago"]))
                    throw new Exception("Seleccione la frecuencia de pago en la lista.");
                if (IsNullOrEmpty((string)e.Values["uid_product"]))
                    throw new Exception("Seleccione un producto de la lista.");
                if (IsNullOrEmpty((string)e.Values["uid_company"]))
                    throw new Exception("Seleccione una compañia de la lista.");

                var i = DBFunciones.IContext.vpolizas.Find(id);
                if (i != null)
                {
                    i.uid_client = (Guid)e.Values["uid_client"];
                    i.no_poliza = (string)e.Values["no_poliza"];
                    i.serie = ((string)e.Values["serie"])?.ToUpper();
                    i.ano = e.Values["ano"] != null && e.Values["ano"].ToString() != "" ? (short?)Convert.ToInt16(e.Values["ano"]) : null;
                    i.fech_inicio = (DateTime)e.Values["fech_inicio"];
                    i.tipo_pago = (string)e.Values["tipo_pago"];
                    i.uid_company = (string)e.Values["uid_company"];
                    i.uid_product = (string)e.Values["uid_product"];
                    DBFunciones.IContext.SaveChanges();
                }
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
        protected void GridView_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            ASPxGridView gridView = sender as ASPxGridView;
            if (e.Column.FieldName == "uid_product")
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
            //if (cpy != Guid.Empty)
            {
                cmb.DataSource = DBFunciones.IContext.vCompany_Products.Where(i => i.uid_company == cpy).AsQueryable().ToList();
                cmb.DataBindItems();
            }
        }
        void cmbProd_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillProdCombo(source as ASPxComboBox, e.Parameter);
        }

        protected void GridView_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == ColumnCommandButtonType.Update || e.ButtonType == ColumnCommandButtonType.Cancel || e.ButtonType == ColumnCommandButtonType.PreviewChanges)
                e.Visible = false;
        }
        private void PrepareGridForExport()
        {
            foreach (var column in gvPolizas.Columns)
            {
                if (column is DevExpress.Web.GridViewColumn gridColumn)
                {
                    // Oculta todo por defecto
                    gridColumn.Visible = false;
                }
            }

            // Muestra solo las columnas deseadas por Name o FieldName
            gvPolizas.Columns["ColNombre"].Visible = true; // Nombre
            gvPolizas.Columns["no_poliza"].Visible = true; // Poliza
            gvPolizas.Columns["serie"].Visible = true; // Poliza
            gvPolizas.Columns["ano"].Visible = true; // Poliza
            gvPolizas.Columns["nxt_pago"].Visible = true;  // Sig. Pago
            gvPolizas.Columns["ColCompany"].Visible = true; //Compañia
            gvPolizas.Columns["ColProd"].Visible = true; //Producto
            gvPolizas.Columns["Evento"].Visible = true; //Evento
        }

        private void ExportGridToPdf()
        {
            PrepareGridForExport();

            // Obtener las claves seleccionadas
            List<object> selectedKeys = gvPolizas.GetSelectedFieldValues("uid_poliza");

            if (selectedKeys.Count > 0)
            {
                // Filtrar el grid para mostrar solo las filas seleccionadas
                gvPolizas.DataSourceID = null; // Desconecta el DataSourceID si es necesario
                gvPolizas.DataSource = GetSelectedData(selectedKeys);
                gvPolizas.DataBind();

                gridExporter.WritePdfToResponse("ReportePolizas", true);
            }

            gridExporter.WritePdfToResponse("ReportePolizas", true);
        }
        private List<vpoliza> GetSelectedData(List<object> selectedKeys)
        {
            var guids = new List<Guid>();

            foreach (var key in selectedKeys)
            {
                if (Guid.TryParse(key.ToString(), out Guid guid))
                {
                    guids.Add(guid);
                }
            }

            using (var db = new ModelClients())
            {
                return db.vpolizas.Where(p => guids.Contains(p.uid_poliza)).ToList();
            }
        }

        protected void gvPolizas_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string filtro = e.Parameters;
            DBFunciones.IContext = null;
            switch (filtro)
            {
                case "Cancelada":
                    gvPolizas.Columns["estatus"].Visible = false;
                    gvPolizas.Columns["nota"].Visible = true;
                    gvPolizas.Columns["Evento"].Visible= false;
                    gvPolizas.FilterExpression = "[estatus] = 'cancelada'";
                    break;
                case "Active":
                    gvPolizas.Columns["estatus"].Visible = false;
                    gvPolizas.Columns["nota"].Visible = false;
                    gvPolizas.Columns["Evento"].Visible = true;
                    gvPolizas.FilterExpression = "[estatus] = 'activa'";
                    break;
                case "Vencida":
                    gvPolizas.Columns["estatus"].Visible = false;
                    gvPolizas.Columns["nota"].Visible = false;
                    gvPolizas.Columns["Evento"].Visible = false;
                    gvPolizas.FilterExpression = "[estatus] = 'vencida'";
                    break;
            }

            gvPolizas.DataBind();

        }
        protected void gvPolizas_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            var dict = new System.Collections.Generic.Dictionary<int, object>();

            // Obtenemos los valores de la página actual de forma eficiente
            // Esto funciona perfectamente con EntityServerMode
            System.Collections.Generic.List<object> rowValues = grid.GetCurrentPageRowValues("no_poliza");
            int startIndex = grid.VisibleStartIndex;

            for (int i = 0; i < rowValues.Count; i++)
            {
                dict[startIndex + i] = rowValues[i];
            }

            e.Properties["cpPolizas"] = dict;
        }

        [WebMethod]
        public static string CancelarPoliza(string uidPoliza, string nota)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ModelClients"].ConnectionString))
                {
                    conn.Open();
                    string query = "UPDATE dbo.polizas SET estatus = 'cancelada', nota = @nota WHERE uid_poliza = @uidPoliza";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@nota", nota);
                        cmd.Parameters.AddWithValue("@uidPoliza", uidPoliza);
                        cmd.ExecuteNonQuery();
                    }
                }

                return "OK";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        protected void gvPolizas_AfterPerformCallback(object sender, ASPxGridViewAfterPerformCallbackEventArgs e)
        {
            // Verificamos si la acción que acaba de ocurrir fue un filtro o el uso del menú lateral
            string callbackName = e.CallbackName.ToUpper();

            if (callbackName.Contains("FILTER") || callbackName == "CUSTOMCALLBACK")
            {
                ASPxGridView grid = (ASPxGridView)sender;

                // Limpia absolutamente todos los checkboxes seleccionados en todas las páginas
                grid.Selection.UnselectAll();
            }
        }
    }
}
