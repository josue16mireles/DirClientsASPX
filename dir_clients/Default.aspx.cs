using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClientsDataModel;
using DevExpress.Data.Linq;
using DevExpress.Web;
using DevExpress.Web.Data;
using DevExpress.XtraScheduler.Outlook.Interop;
using dir_clients.Classes;
using dir_clients.Model;
using static System.String;
using Exception = System.Exception;

namespace dir_clients
{
    public partial class ClientsDir : Page
    {
        private Guid _UIDClient;
        public Guid UIDClient
        {
            set => _UIDClient = value;
            get 
            { 
                return _UIDClient;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                Session["uidmov"] = null;
                GridView.DataBind();
            }
        }
        protected void GridView_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {   
            GridView.DataBind();
        }
        protected void dsClients_Selecting(object sender, LinqServerModeDataSourceSelectEventArgs e)
        {
            e.QueryableSource = DBFunciones.IContext.vclients.AsQueryable();
            e.KeyExpression = "uid_client";
            e.DefaultSorting = "nombre";
        }

        protected void dsClients_Inserting(object sender, LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                DBFunciones.IContext = null;
                if (IsNullOrEmpty((string)e.Values["nombre"]))
                    throw new Exception("Ingrese un nombre en el campo.");
                if (IsNullOrEmpty((string)e.Values["direccion"]))
                    throw new Exception("Ingrese una dirección en el campo.");

                var i = new vclient
                {
                    uid_client = Guid.NewGuid(),
                    nombre = (string)e.Values["nombre"],
                    direccion = (string)e.Values["direccion"],
                    telefono = (string)e.Values["telefono"],
                    celular = (string)e.Values["celular"],
                    email = (string)e.Values["email"],
                    email2 = (string)e.Values["email2"],
                    relacionado = (string)e.Values["relacionado"],
                    archivero = (string)e.Values["archivero"]
                };
                DBFunciones.IContext.vclients.Add(i);
                DBFunciones.IContext.SaveChanges();
                e.Handled = true;
                DBFunciones.IContext = null;
            }
            catch(DbEntityValidationException x)
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
            catch (Exception ex)
            {
                var dbUpdateEx = ex as System.Data.Entity.Infrastructure.DbUpdateException;

                if (dbUpdateEx != null && dbUpdateEx.InnerException != null)
                {
                    // EntityException -> UpdateException -> SqlException
                    var innerEx = dbUpdateEx.InnerException;

                    // A veces hay una segunda inner exception
                    if (innerEx.InnerException is System.Data.SqlClient.SqlException sqlEx)
                    {
                        foreach (System.Data.SqlClient.SqlError error in sqlEx.Errors)
                        {
                            // Aquí puedes filtrar o simplemente usar el mensaje
                            Session["CpyProdErrorMessage"] = error.Message;
                            throw new Exception("Error al agregar: " + error.Message);
                        }
                    }
                }

                // Si no se logró capturar el mensaje SQL, mostrar el genérico
                Session["CpyProdErrorMessage"] = ex.Message;
                throw new Exception("Error al agregar: " + ex.Message);
            }
        }

        protected void dsClients_Updating(object sender, LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                DBFunciones.IContext = null;
                var id = (Guid)e.Keys[GridView.KeyFieldName];

                var i = DBFunciones.IContext.vclients.Find(id);
                if (i != null)
                {
                    i.nombre = (string)e.Values["nombre"];
                    i.direccion = (string)e.Values["direccion"];
                    i.telefono = (string)e.Values["telefono"] ;
                    i.celular = (string)e.Values["celular"];
                    i.email = (string)e.Values["email"];
                    i.email2 = (string)e.Values["email2"];
                    i.relacionado = (string)e.Values["relacionado"];
                    i.archivero = (string)e.Values["archivero"];
                    DBFunciones.IContext.SaveChanges();
                }
                e.Handled= true;
                DBFunciones.IContext = null;
            }
            catch (DbEntityValidationException t)
            {
                foreach(var eve in t.EntityValidationErrors)
                {
                    Console.WriteLine(@"La entidad de tipo ""{0}"" en el estado ""{1}"" tiene los siguientes errores de validación:",
                        eve.Entry.Entity.GetType().Name, eve.Entry.State);
                    foreach (var ve in eve.ValidationErrors)
                        Console.WriteLine(@"La entidad de tipo ""{0}"" en el estado ""{1}"" tiene los siguientes errores de validación:",
                            ve.PropertyName, ve.ErrorMessage);
                }
            }
            catch (Exception ex)
            {
                var dbUpdateEx = ex as System.Data.Entity.Infrastructure.DbUpdateException;

                if (dbUpdateEx != null && dbUpdateEx.InnerException != null)
                {
                    // EntityException -> UpdateException -> SqlException
                    var innerEx = dbUpdateEx.InnerException;

                    // A veces hay una segunda inner exception
                    if (innerEx.InnerException is System.Data.SqlClient.SqlException sqlEx)
                    {
                        foreach (System.Data.SqlClient.SqlError error in sqlEx.Errors)
                        {
                            // Aquí puedes filtrar o simplemente usar el mensaje
                            Session["CpyProdErrorMessage"] = error.Message;
                            throw new Exception("Error al actualizar: " + error.Message);
                        }
                    }
                }

                // Si no se logró capturar el mensaje SQL, mostrar el genérico
                Session["CpyProdErrorMessage"] = ex.Message;
                throw new Exception("Error al actualizar: " + ex.Message);
            }
        }
        protected void GridView_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == dsClients.ID)
                x.CancelEdit();
        }
        protected void GridView_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == dsClients.ID)
                x.CancelEdit();
        }
        protected void GridView_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            var x = (ASPxGridView)sender;
            if (x != null && x.DataSourceID == dsClients.ID)
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
            var d = e.Parameter.Split('|');
            var opcion = d[0]?.ToString();
            Session["_vclient"] = null;
                        
            switch (opcion)
            {
                case "Editar":
                    try 
                    {
                        Session["uidmov"] = null;
                        Guid.TryParse(d[1], out Guid outs);
                        DBFunciones.IContext = null;
                        Session["uidmov"] = outs;
                        if (outs == Guid.Empty)
                        {
                            opcion = "Error";
                        }
                    }
                    catch (Exception x)
                    {
                        opcion = x.Message;
                    }
                    break;
                default:
                    GridView.DataBind();
                    break;
            }
            e.Result = opcion;
            
        }
    }
}