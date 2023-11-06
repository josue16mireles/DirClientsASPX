namespace ClientsDataModel.test
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("vprodpol")]
    public partial class vprodpol
    {
        [Key]
        public Guid uid_prodpol { get; set; }

        public Guid? uid_company { get; set; }

        [StringLength(50)]
        public string prodpol { get; set; }
    }
}
