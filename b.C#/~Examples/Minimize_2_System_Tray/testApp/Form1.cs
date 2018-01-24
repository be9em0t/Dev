using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace MinimizeToTray
{
    public partial class TrayMinimizerForm : Form
    {
        public TrayMinimizerForm()
        {
            InitializeComponent();
        }


        private void TrayMinimizerForm_Resize(object sender, EventArgs e)
        {
            notifyIcon1.BalloonTipTitle = "Minimize to Tray App";
            notifyIcon1.BalloonTipText = "You have successfully minimized your form.";

            if (FormWindowState.Minimized == this.WindowState)
            {
                notifyIcon1.Visible = true;
                notifyIcon1.ShowBalloonTip(500);
                this.Hide();    
            }
            else if (FormWindowState.Normal == this.WindowState)
            {
                notifyIcon1.Visible = false;
            }
        }

        private void notifyIcon1_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            this.Show();
            this.WindowState = FormWindowState.Normal;
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            System.Environment.Exit(0);
        }
    }
}