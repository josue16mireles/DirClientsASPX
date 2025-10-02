using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace dir_clients.Classes
{
    public class DBFunciones
    {
        private static ClientsDataModel.ModelClients _iContext;
        public static ClientsDataModel.ModelClients IContext
        {
            get
            {
                if (_iContext == null)
                    _iContext = new ClientsDataModel.ModelClients();
                return _iContext;
            }
            set { _iContext = value; }
        }

        public static void IsGuid(string uid, out Guid uidout)
        {
            Guid.TryParse(uid, out uidout);
        }
    }
}