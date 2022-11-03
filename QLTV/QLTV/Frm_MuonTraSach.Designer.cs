namespace QLTV
{
    partial class Frm_MuonTraSach
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtMaDocGia = new System.Windows.Forms.TextBox();
            this.btn_TraCuu = new System.Windows.Forms.Button();
            this.dgv_MuonSach = new System.Windows.Forms.DataGridView();
            this.txt_ISBN = new System.Windows.Forms.TextBox();
            this.txtMaCuonSach = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.btnTraSach = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dgv_MuonSach)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F);
            this.label1.Location = new System.Drawing.Point(227, 7);
            this.label1.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(142, 20);
            this.label1.TabIndex = 0;
            this.label1.Text = "MƯỢN TRẢ SÁCH";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F);
            this.label2.Location = new System.Drawing.Point(44, 49);
            this.label2.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(142, 17);
            this.label2.TabIndex = 1;
            this.label2.Text = "Nhập vào mã độc giả";
            // 
            // txtMaDocGia
            // 
            this.txtMaDocGia.Location = new System.Drawing.Point(208, 45);
            this.txtMaDocGia.Margin = new System.Windows.Forms.Padding(2);
            this.txtMaDocGia.Name = "txtMaDocGia";
            this.txtMaDocGia.Size = new System.Drawing.Size(115, 20);
            this.txtMaDocGia.TabIndex = 2;
            // 
            // btn_TraCuu
            // 
            this.btn_TraCuu.Location = new System.Drawing.Point(370, 46);
            this.btn_TraCuu.Margin = new System.Windows.Forms.Padding(2);
            this.btn_TraCuu.Name = "btn_TraCuu";
            this.btn_TraCuu.Size = new System.Drawing.Size(56, 19);
            this.btn_TraCuu.TabIndex = 3;
            this.btn_TraCuu.Text = "Tra cứu";
            this.btn_TraCuu.UseVisualStyleBackColor = true;
            this.btn_TraCuu.Click += new System.EventHandler(this.btn_TraCuu_Click_1);
            // 
            // dgv_MuonSach
            // 
            this.dgv_MuonSach.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgv_MuonSach.Location = new System.Drawing.Point(55, 115);
            this.dgv_MuonSach.Margin = new System.Windows.Forms.Padding(2);
            this.dgv_MuonSach.Name = "dgv_MuonSach";
            this.dgv_MuonSach.RowHeadersWidth = 51;
            this.dgv_MuonSach.RowTemplate.Height = 24;
            this.dgv_MuonSach.Size = new System.Drawing.Size(372, 158);
            this.dgv_MuonSach.TabIndex = 4;
            // 
            // txt_ISBN
            // 
            this.txt_ISBN.Location = new System.Drawing.Point(90, 301);
            this.txt_ISBN.Margin = new System.Windows.Forms.Padding(2);
            this.txt_ISBN.Name = "txt_ISBN";
            this.txt_ISBN.Size = new System.Drawing.Size(77, 20);
            this.txt_ISBN.TabIndex = 2;
            // 
            // txtMaCuonSach
            // 
            this.txtMaCuonSach.Location = new System.Drawing.Point(373, 304);
            this.txtMaCuonSach.Margin = new System.Windows.Forms.Padding(2);
            this.txtMaCuonSach.Name = "txtMaCuonSach";
            this.txtMaCuonSach.Size = new System.Drawing.Size(77, 20);
            this.txtMaCuonSach.TabIndex = 2;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F);
            this.label3.Location = new System.Drawing.Point(52, 301);
            this.label3.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(34, 17);
            this.label3.TabIndex = 1;
            this.label3.Text = "isbn";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F);
            this.label4.Location = new System.Drawing.Point(273, 304);
            this.label4.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(96, 17);
            this.label4.TabIndex = 1;
            this.label4.Text = "Mã cuốn sách";
            // 
            // btnTraSach
            // 
            this.btnTraSach.Location = new System.Drawing.Point(208, 336);
            this.btnTraSach.Margin = new System.Windows.Forms.Padding(2);
            this.btnTraSach.Name = "btnTraSach";
            this.btnTraSach.Size = new System.Drawing.Size(69, 19);
            this.btnTraSach.TabIndex = 3;
            this.btnTraSach.Text = "Trả sách";
            this.btnTraSach.UseVisualStyleBackColor = true;
            this.btnTraSach.Click += new System.EventHandler(this.btnTraSach_Click_1);
            // 
            // Frm_MuonTraSach
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(600, 366);
            this.Controls.Add(this.dgv_MuonSach);
            this.Controls.Add(this.btnTraSach);
            this.Controls.Add(this.btn_TraCuu);
            this.Controls.Add(this.txtMaCuonSach);
            this.Controls.Add(this.txt_ISBN);
            this.Controls.Add(this.txtMaDocGia);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Margin = new System.Windows.Forms.Padding(2);
            this.Name = "Frm_MuonTraSach";
            this.Text = "Frm_MuonTraSach";
            ((System.ComponentModel.ISupportInitialize)(this.dgv_MuonSach)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtMaDocGia;
        private System.Windows.Forms.Button btn_TraCuu;
        private System.Windows.Forms.DataGridView dgv_MuonSach;
        private System.Windows.Forms.TextBox txt_ISBN;
        private System.Windows.Forms.TextBox txtMaCuonSach;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnTraSach;
    }
}