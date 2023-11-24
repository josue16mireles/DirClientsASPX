namespace ClientsDataModel.test
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class vpoliza
    {
        [Key]
        [Column(Order = 0)]
        public Guid uid_poliza { get; set; }

        [Key]
        [Column(Order = 1)]
        public Guid uid_client { get; set; }

        [StringLength(100)]
        public string nombre { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(50)]
        public string no_poliza { get; set; }

        [Key]
        [Column(Order = 3)]
        public DateTime fech_inicio { get; set; }

        public DateTime? fech_vencimiento { get; set; }

        [StringLength(10)]
        public string FrecuenciaDePago { get; set; }

        public DateTime? nxt_pago { get; set; }

        [Key]
        [Column(Order = 4)]
        public Guid uid_prodpol { get; set; }

        [StringLength(50)]
        public string prodpol { get; set; }

        [Key]
        [Column(Order = 5)]
        [StringLength(5)]
        public string tipo_pago { get; set; }

        [StringLength(250)]
        public string uid_company { get; set; }

        [StringLength(50)]
        public string company { get; set; }

        [StringLength(7)]
        public string estatus { get; set; }
    }
}
