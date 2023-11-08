using ClientsDataModel.test;
using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace ClientsDataModel
{
    public partial class ModelClients : DbContext
    {
        public ModelClients()
            : base("name=ModelClients")
        {
        }

        public virtual DbSet<vclient> vclients { get; set; }
        public virtual DbSet<vpoliza> vpolizas { get; set; }
        public virtual DbSet<vcpy_prod> vcpy_prod { get; set; }
        public virtual DbSet<vcompany> vcompanies { get; set; }
        public virtual DbSet<vprodpol> vprodpols { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<vpoliza>()
                .Property(e => e.FrecuenciaDePago)
                .IsUnicode(false);

            modelBuilder.Entity<vpoliza>()
                .Property(e => e.tipo_pago)
                .IsUnicode(false);

        }
    }
}
