using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace DesktopIcons
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            listBox1.Items.Clear();
            RemoteListView.LVItem[] lvl = RemoteListView.GetListView(   "Progman", "Program Manager", // Program Window Caption and Class
                                                                        "SysListView32", "FolderView"); // ListView Caption and Class
            foreach (RemoteListView.LVItem item in lvl)
                listBox1.Items.Add(item.Name + " @ " + item.Location.ToString());
        }
    }
}
