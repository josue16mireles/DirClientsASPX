namespace ClientsDataModel
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("vcompany")]
    public partial class vcompany
    {
        [Key]
        [Column(Order = 0)]
        public Guid uid_company { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(50)]
        public string company { get; set; }
    }
}
