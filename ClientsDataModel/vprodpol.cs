namespace ClientsDataModel
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("vprodpol")]
    public partial class vprodpol
    {
        [StringLength(250)]
        public string uid_prodpol { get; set; }

        [StringLength(250)]
        public string uid_company { get; set; }

        [Key]
        [StringLength(50)]
        public string prodpol { get; set; }
    }
}
