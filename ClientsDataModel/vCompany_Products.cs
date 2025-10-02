namespace ClientsDataModel.test
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class vCompany_Products
    {
        [Key]
        public Guid UID_Principal { get; set; }

        [StringLength(50)]
        public string company { get; set; }

        [StringLength(250)]
        public string uid_company { get; set; }

        [StringLength(50)]
        public string Producto { get; set; }

        [StringLength(250)]
        public string uid_product { get; set; }
    }
}
