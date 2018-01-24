namespace DeskPilotForms
{
    partial class Form1
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
      this.components = new System.ComponentModel.Container();
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
      this.button1 = new System.Windows.Forms.Button();
      this.button2 = new System.Windows.Forms.Button();
      this.notifyIcon1 = new System.Windows.Forms.NotifyIcon(this.components);
      this.listBox1TopWin = new System.Windows.Forms.ListBox();
      this.listBox2ChildWin = new System.Windows.Forms.ListBox();
      this.button4 = new System.Windows.Forms.Button();
      this.treeViewWin = new System.Windows.Forms.TreeView();
      this.SuspendLayout();
      // 
      // button1
      // 
      this.button1.FlatAppearance.BorderSize = 0;
      this.button1.Location = new System.Drawing.Point(411, 50);
      this.button1.Name = "button1";
      this.button1.Size = new System.Drawing.Size(110, 30);
      this.button1.TabIndex = 0;
      this.button1.Text = "Test Notepad";
      this.button1.UseVisualStyleBackColor = true;
      this.button1.Click += new System.EventHandler(this.button1_Click);
      // 
      // button2
      // 
      this.button2.Font = new System.Drawing.Font("Segoe UI", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.button2.Location = new System.Drawing.Point(250, 219);
      this.button2.Name = "button2";
      this.button2.Size = new System.Drawing.Size(110, 30);
      this.button2.TabIndex = 1;
      this.button2.Text = "Refresh";
      this.button2.UseVisualStyleBackColor = true;
      this.button2.Click += new System.EventHandler(this.buttonListProc_Click);
      // 
      // notifyIcon1
      // 
      this.notifyIcon1.Icon = ((System.Drawing.Icon)(resources.GetObject("notifyIcon1.Icon")));
      this.notifyIcon1.Text = "notifyIcon1";
      this.notifyIcon1.Visible = true;
      this.notifyIcon1.MouseClick += new System.Windows.Forms.MouseEventHandler(this.notifyIcon1_MouseClick);
      // 
      // listBox1TopWin
      // 
      this.listBox1TopWin.FormattingEnabled = true;
      this.listBox1TopWin.Location = new System.Drawing.Point(250, 14);
      this.listBox1TopWin.Name = "listBox1TopWin";
      this.listBox1TopWin.Size = new System.Drawing.Size(144, 108);
      this.listBox1TopWin.TabIndex = 3;
      this.listBox1TopWin.Click += new System.EventHandler(this.listBox1_Click);
      // 
      // listBox2ChildWin
      // 
      this.listBox2ChildWin.FormattingEnabled = true;
      this.listBox2ChildWin.Location = new System.Drawing.Point(618, 11);
      this.listBox2ChildWin.Name = "listBox2ChildWin";
      this.listBox2ChildWin.Size = new System.Drawing.Size(144, 238);
      this.listBox2ChildWin.TabIndex = 4;
      // 
      // button4
      // 
      this.button4.Location = new System.Drawing.Point(411, 86);
      this.button4.Name = "button4";
      this.button4.Size = new System.Drawing.Size(60, 53);
      this.button4.TabIndex = 5;
      this.button4.Text = "button4";
      this.button4.UseVisualStyleBackColor = true;
      this.button4.Click += new System.EventHandler(this.button4_Click);
      // 
      // treeViewWin
      // 
      this.treeViewWin.CheckBoxes = true;
      this.treeViewWin.Location = new System.Drawing.Point(12, 14);
      this.treeViewWin.Name = "treeViewWin";
      this.treeViewWin.Size = new System.Drawing.Size(232, 235);
      this.treeViewWin.TabIndex = 6;
      this.treeViewWin.Click += new System.EventHandler(this.treeViewWin_Click);
      this.treeViewWin.DoubleClick += new System.EventHandler(this.treeViewWin_DoubleClick);
      // 
      // Form1
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(774, 265);
      this.Controls.Add(this.treeViewWin);
      this.Controls.Add(this.button4);
      this.Controls.Add(this.listBox2ChildWin);
      this.Controls.Add(this.listBox1TopWin);
      this.Controls.Add(this.button2);
      this.Controls.Add(this.button1);
      this.Font = new System.Drawing.Font("Segoe UI", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.Name = "Form1";
      this.Text = "DeskPilot";
      this.Resize += new System.EventHandler(this.Form1_Resize);
      this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.NotifyIcon notifyIcon1;
        private System.Windows.Forms.ListBox listBox1TopWin;
        private System.Windows.Forms.ListBox listBox2ChildWin;
        private System.Windows.Forms.Button button4;
      private System.Windows.Forms.TreeView treeViewWin;
   }
}

