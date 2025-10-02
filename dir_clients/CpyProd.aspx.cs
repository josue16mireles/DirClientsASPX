using ClientsDataModel;
using ClientsDataModel.test;
using DevExpress.Web;
using DevExpress.Web.Data;
using dir_clients.Classes;
using System;
using System.Data.Entity.Validation;
using System.Linq;
using System.Web.UI.WebControls;
using static System.String;

namespace dir_clients
{
    public partial class CpyProd : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void dsCompany_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.QueryableSource = DBFunciones.IContext.vcompanies.AsQueryable();
            e.KeyExpression = "uid_company";
            e.DefaultSorting = "company";
        }

        protected void dsCompany_Inserting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                DBFunciones.IContext = null;

                if (IsNullOrEmpty((string)e.Values["company"]))
                    throw new Exception("Ingrese una compañia en el campo.");

                var i = new vcompany
                {
                    uid_company = Guid.NewGuid().ToString(),
                    company = (string)e.Values["company"],
                };
                DBFunciones.IContext.vcompanies.Add(i);
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
                            Session["CompanyErrorMessage"] = error.Message;
                            throw new Exception("Error al agregar la compañía: " + error.Message);
                        }
                    }
                }

                // Si no se logró capturar el mensaje SQL, mostrar el genérico
                Session["CompanyErrorMessage"] = ex.Message;
                throw new Exception("Error al agregar la compañía: " + ex.Message);
            }
        }

        protected void dsCompany_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                DBFunciones.IContext = null;

                var id = (string)e.Keys[gvCompany.KeyFieldName];

                if (IsNullOrEmpty((string)e.Values["company"]))
                    throw new Exception("Ingrese una compañia en el campo.");

                var i = DBFunciones.IContext.vcompanies.Find(id);
                if (i != null)
                {
                    i.company = (string)e.Values["company"];
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
                            Session["CompanyErrorMessage"] = error.Message;
                            throw new Exception("Error al actualizar la compañía: " + error.Message);
                        }
                    }
                }

                // Si no se logró capturar el mensaje SQL, mostrar el genérico
                Session["CompanyErrorMessage"] = ex.Message;
                throw new Exception("Error al actualizar la compañía: " + ex.Message);
            }
        }

        protected void dsProduct_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.QueryableSource = DBFunciones.IContext.vproducts.AsQueryable();
            e.KeyExpression = "uid_product";
            e.DefaultSorting = "Producto";
        }

        protected void dsProduct_Inserting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                DBFunciones.IContext = null;

                if (IsNullOrEmpty((string)e.Values["Producto"]))
                    throw new Exception("Ingrese una producto en el campo.");

                var i = new vproduct
                {
                    uid_product = Guid.NewGuid().ToString(),
                    Producto = (string)e.Values["Producto"],
                };
                DBFunciones.IContext.vproducts.Add(i);
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
                            Session["ProductErrorMessage"] = error.Message;
                            throw new Exception("Error al agregar el producto: " + error.Message);
                        }
                    }
                }

                // Si no se logró capturar el mensaje SQL, mostrar el genérico
                Session["ProductErrorMessage"] = ex.Message;
                throw new Exception("Error al agregar el producto: " + ex.Message);
            }
        }

        protected void dsProduct_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                DBFunciones.IContext = null;
                var id = (string)e.Keys[gvProductos.KeyFieldName];

                if (IsNullOrEmpty((string)e.Values["Producto"]))
                    throw new Exception("Ingrese un producto en el campo.");

                var i = DBFunciones.IContext.vproducts.Find(id);
                if (i != null)
                {
                    i.Producto = (string)e.Values["Producto"];
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
                            Session["ProductErrorMessage"] = error.Message;
                            throw new Exception("Error al actualizar el producto: " + error.Message);
                        }
                    }
                }

                // Si no se logró capturar el mensaje SQL, mostrar el genérico
                Session["ProductErrorMessage"] = ex.Message;
                throw new Exception("Error al actualizar el producto: " + ex.Message);
            }
        }

        protected void dsCpyProducts_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            e.QueryableSource = DBFunciones.IContext.vCompany_Products.AsQueryable();
            e.KeyExpression = "UID_Principal";
            e.DefaultSorting = "company";
        }

        protected void dsCpyProducts_Inserting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                DBFunciones.IContext = null;
                if (IsNullOrEmpty((string)e.Values["uid_company"]))
                    throw new Exception("Ingrese una compañia en el campo.");
                if (IsNullOrEmpty((string)e.Values["uid_product"]))
                    throw new Exception("Ingrese un producto en el campo.");


                var i = new vCompany_Products
                {
                    UID_Principal = Guid.NewGuid(),
                    uid_company = (string)e.Values["uid_company"],
                    uid_product = (string)e.Values["uid_product"]
                };
                DBFunciones.IContext.vCompany_Products.Add(i);
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
                            throw new Exception("Error al agregar la relación compañia - producto: " + error.Message);
                        }
                    }
                }

                // Si no se logró capturar el mensaje SQL, mostrar el genérico
                Session["CpyProdErrorMessage"] = ex.Message;
                throw new Exception("Error al agregar la relación compañia - producto: " + ex.Message);
            }
        }

        protected void dsCpyProducts_Updating(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceEditEventArgs e)
        {
            try
            {
                DBFunciones.IContext = null;
                var id = (Guid)e.Keys[gvCpyProds.KeyFieldName];

                if (IsNullOrEmpty((string)e.Values["uid_company"]))
                    throw new Exception("Ingrese una compañia en el campo.");
                if (IsNullOrEmpty((string)e.Values["uid_product"]))
                    throw new Exception("Ingrese un producto en el campo.");

                var i = DBFunciones.IContext.vCompany_Products.Find(id);
                if (i != null)
                {
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
                            throw new Exception("Error al actualizar la relación compañía - producto: " + error.Message);
                        }
                    }
                }

                // Si no se logró capturar el mensaje SQL, mostrar el genérico
                Session["CpyProdErrorMessage"] = ex.Message;
                throw new Exception("Error al actualizar la relación compañía - producto: " + ex.Message);
            }
        }

        protected void gvCpyProds_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            dsCpy.DataBind();       // Recarga el ComboBox de compañías
            dsProducto.DataBind();
            gvCpyProds.DataBind();  // Recarga la tabla
        }
    }
}