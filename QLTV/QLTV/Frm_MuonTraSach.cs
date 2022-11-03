using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLTV
{
    public partial class Frm_MuonTraSach : Form
    {
        Database db;
        SqlDataReader dr = null;
        public Frm_MuonTraSach()
        {
            InitializeComponent();
            db = new Database();
        }
        private void btn_TraCuu_click(object sender, EventArgs e)
        {
            
        }
        public void TraCuu()
        {
            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = db.sqlConn;
                db.sqlConn.Open();
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.CommandText = "sp_tracuu_docgia_dangmuonsach";
                cmd.Parameters.Add(new SqlParameter("@madg", Convert.ToInt32(txtMaDocGia.Text)));
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                dgv_MuonSach.DataSource = dt;
                db.sqlConn.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Thêm không thành công");
            }
        }
        private void dgv_MuonSach_SelectionChanged(object sender, EventArgs e)
        {
            int index = dgv_MuonSach.CurrentCell.RowIndex;
            try
            {
                txt_ISBN.Text = dgv_MuonSach.Rows[index].Cells[0].Value.ToString().Trim();
                txtMaCuonSach.Text = dgv_MuonSach.Rows[index].Cells[1].Value.ToString().Trim();
            }
            catch (Exception ex)
            {

            }
        }
        private void btnTraSach_Click(object sender, EventArgs e)
        {
           
        }

        private void btn_TraCuu_Click_1(object sender, EventArgs e)
        {
            TraCuu();
        }

        private void btnTraSach_Click_1(object sender, EventArgs e)
        {
            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = db.sqlConn;
                db.sqlConn.Open();
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.CommandText = "sp_trasach";
                cmd.Parameters.Add(new SqlParameter("@isbn", Convert.ToInt32(txt_ISBN.Text)));
                cmd.Parameters.Add(new SqlParameter("@ma_cuonsach", Convert.ToInt32(txtMaCuonSach.Text)));
                cmd.ExecuteNonQuery();
                MessageBox.Show("Trả sách thành công");
                db.sqlConn.Close();
                TraCuu();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Thêm không thành công");
            }
        }
    } }

