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
        [StringLength(250)]
        public string uid_company { get; set; }

        [StringLength(50)]
        public string company { get; set; }
    }
}
