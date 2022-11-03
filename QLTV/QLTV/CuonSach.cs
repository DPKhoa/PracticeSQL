using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLTV
{
    internal class CuonSach
    {
        Database db;
        public CuonSach()
        {
            db = new Database();
        }
        public void ThemCuonSach(int isbn)
        {
            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = db.sqlConn;
                db.sqlConn.Open();
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.CommandText = "sp_ThemCuonSach";
                cmd.Parameters.Add(new SqlParameter("@isbn", isbn));
                cmd.ExecuteNonQuery();
                MessageBox.Show("Thêm thành công");
            }
            catch(Exception ex)
            {
                MessageBox.Show("Thêm không thành công");
            }
        }
        
    }
}
