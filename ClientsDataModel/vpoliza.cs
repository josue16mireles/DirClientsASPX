namespace ClientsDataModel
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

        [StringLength(50)]
        public string nombre { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(50)]
        public string no_poliza { get; set; }

        [Key]
        [Column(Order = 3)]
        public DateTime fech_inicio { get; set; }

        [Key]
        [Column(Order = 4)]
        public DateTime fech_vencimiento { get; set; }

        [StringLength(15)]
        public string FrecuenciaDePago { get; set; }

        public DateTime? nxt_pago { get; set; }

        [Key]
        [Column(Order = 5)]
        public Guid uid_prod_pol { get; set; }

        [StringLength(50)]
        public string prodpol { get; set; }

        [Key]
        [Column(Order = 6)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int tipo_pago { get; set; }

        [Key]
        [Column(Order = 7)]
        public Guid uid_company { get; set; }

        [StringLength(50)]
        public string company { get; set; }
    }
}
