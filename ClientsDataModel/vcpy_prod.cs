namespace ClientsDataModel
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class vcpy_prod
    {
        [Key]
        [Column(Order = 0)]
        public Guid uid_company { get; set; }

        //[Key]
        //[Column(Order = 1)]
        //[StringLength(50)]
        public string company { get; set; }

        public Guid? uid_prodpol { get; set; }

        [StringLength(50)]
        public string prodpol { get; set; }
    }
}
