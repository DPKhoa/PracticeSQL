using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLTV
{
    internal class Database
    {
        public SqlConnection sqlConn { get; set; }
        public Database()
        {
            string strCnn = "Data Source=.; Database = QLTV; Integrated Security =True";
            sqlConn = new SqlConnection(strCnn);
        }
    }
    
}
