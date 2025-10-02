//using ClientsDataModel.test;
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
        public virtual DbSet<vcompany> vcompanies { get; set; }
        public virtual DbSet<vproduct> vproducts { get; set; }
        public virtual DbSet<vCompany_Products> vCompany_Products { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<vpoliza>()
                 .Property(e => e.FrecuenciaDePago)
                 .IsUnicode(false);

            modelBuilder.Entity<vpoliza>()
                .Property(e => e.uid_product)
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
            modelBuilder.Entity<vpoliza>()
                .Property(e => e.Evento)
                .IsUnicode(false);
            modelBuilder.Entity<vcompany>()
                .Property(e => e.uid_company)
                .IsUnicode(false);

            modelBuilder.Entity<vproduct>()
                .Property(e => e.uid_product)
                .IsUnicode(false);

            modelBuilder.Entity<vCompany_Products>()
                .Property(e => e.uid_company)
                .IsUnicode(false);
            modelBuilder.Entity<vCompany_Products>()
                .Property(e => e.uid_product)
                .IsUnicode(false);

        }
    }
}
