namespace ClientsDataModel
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class vclient
    {
        [Key]
        [Column(Order = 0)]
        public Guid uid_client { get; set; }

        public string nombre { get; set; }

        [StringLength(100)]
        public string direccion { get; set; }

        [StringLength(15)]
        public string telefono { get; set; }

        [StringLength(15)]
        public string celular { get; set; }

        [StringLength(100)]
        public string email { get; set; }

        [StringLength(100)]
        public string email2 { get; set; }

        public int canpol { get; set; }

        public string relacionado { get; set; }
        [StringLength(30)]
        public string archivero { get; set; }
    }
}
