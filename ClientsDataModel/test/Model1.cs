using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace ClientsDataModel.test
{
    public partial class Model1 : DbContext
    {
        public Model1()
            : base("name=Model115")
        {
        }

        public virtual DbSet<vpoliza> vpolizas { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<vpoliza>()
                .Property(e => e.FrecuenciaDePago)
                .IsUnicode(false);

            modelBuilder.Entity<vpoliza>()
                .Property(e => e.tipo_pago)
                .IsUnicode(false);

            modelBuilder.Entity<vpoliza>()
                .Property(e => e.uid_company)
                .IsUnicode(false);

            modelBuilder.Entity<vpoliza>()
                .Property(e => e.estatus)
                .IsUnicode(false);
        }
    }
}
