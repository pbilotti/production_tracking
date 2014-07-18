using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;

namespace ProductionTrackingMonitor
{
    /// Provides the client the interface for fetching the data from the database
    /// 
    [Serializable]
    public class Caja
    {
        public int left { get; set; }
        public int right { get; set; }
        public int cont { get; set; }
    }


    [WebService(Namespace = "http://algo.org/webservices")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class FetchDBWebService : System.Web.Services.WebService
    {

        [WebMethod]
        public string FetchData()
        {
            var jss = new JavaScriptSerializer();

            var json = new
            {
                altas = new Caja() { left = 20, cont = 10, right = 30 },
                inyectado = new Caja() { left = 30, cont = 2, right = 81 },
                altas_inyectado = 10
            };

            return jss.Serialize(json);;
        }
    }
}
