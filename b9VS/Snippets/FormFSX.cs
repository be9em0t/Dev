using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using pin = PInvoke;
//using static PInvoke.User32;
using FSUIPC;


namespace FSX_b9
{
    public partial class FormFSX : Form
    {
        // Standard P/Invoke example
        [DllImport("user32.dll", SetLastError = true)]
        internal static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

        // Find window
        [DllImport("user32.dll", EntryPoint = "FindWindow", SetLastError = true)]
        static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool IsWindow(IntPtr hWnd);

        //enum window-related
        protected delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

        [DllImport("user32.dll", CharSet = CharSet.Unicode)]
        protected static extern int GetWindowText(IntPtr hWnd, StringBuilder strText, int maxCount);

        [DllImport("user32.dll", CharSet = CharSet.Unicode)]
        protected static extern int GetWindowTextLength(IntPtr hWnd);

        [DllImport("user32.dll")]
        protected static extern bool EnumWindows(EnumWindowsProc enumProc, IntPtr lParam);

        [DllImport("user32.dll")]
        protected static extern bool IsWindowVisible(IntPtr hWnd);

        // original example - unused
        protected static bool EnumTheWindowsOrg(IntPtr hWnd, IntPtr lParam)
        {
            int size = GetWindowTextLength(hWnd);
            Console.WriteLine(size);
            if (size++ > 0 && IsWindowVisible(hWnd))
            {
                StringBuilder sb = new StringBuilder(size);
                GetWindowText(hWnd, sb, size);
                Console.WriteLine(sb.ToString());
            }
            return true;
        }

        protected static bool EnumTheWindows(IntPtr hWnd, IntPtr lParam)
        {
            int size = GetWindowTextLength(hWnd);
            if (size++ > 0 && IsWindowVisible(hWnd))
            {
                StringBuilder sb = new StringBuilder(size);
                GetWindowText(hWnd, sb, size);
                Console.WriteLine(size + " " + hWnd + " " + sb.ToString());
            }
            return true;
        }

        IntPtr Hndl;
        string progClass = "FS98FLOAT";
        string progTitle = "ATC Menu";

        public FormFSX()
        {
            //checkProgExists();
            InitializeComponent();

        }


        private bool checkProgExists()
        {
            Hndl = FindWindow(progClass, progTitle);

            if (IsWindow(Hndl))
            {
                MessageBox.Show("handle is " + Hndl);
                return true;
            }
            else
            {
                MessageBox.Show("no handle. " + Hndl);
                return false;
            }
        }

        private void btnFSXState_Click(object sender, EventArgs e)
        {
            lblStatus.BackColor = Color.LightGreen;
            Console.WriteLine("===============START================");
            EnumWindows(new EnumWindowsProc(EnumTheWindows), IntPtr.Zero);
            Console.WriteLine("===============END================");

            foreach (var screen in Screen.AllScreens)
            {
                // For each screen, add the screen properties to a list box.
                Console.WriteLine("Device Name: " + screen.DeviceName);
                Console.WriteLine("Bounds: " + screen.Bounds.ToString());
                Console.WriteLine("Type: " + screen.GetType().ToString());
                Console.WriteLine("Working Area: " + screen.WorkingArea.ToString());
                Console.WriteLine("Primary Screen: " + screen.Primary.ToString());
            }

            try
            {
                // Attempt to open a connection to FSUIPC (running on any version of Flight Sim)
                FSUIPCConnection.Open();
                // Opened OK
            }
            catch (Exception ex)
            {
                // Badness occurred - show the error message
                MessageBox.Show(ex.Message, "AppTitle", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnPushback_Click(object sender, EventArgs e)
        {
            //Hndl = pin.User32.FindWindow(progClass, progTitle);
            Hndl = pin.User32.FindWindowEx(IntPtr.Zero, IntPtr.Zero, progClass, progTitle);
            pin.User32.SetForegroundWindow(Hndl);
            Console.WriteLine(Hndl);
            PInvoke.RECT area;
            pin.User32.GetWindowRect(Hndl, out area);
            Console.WriteLine(pin.User32.SetWindowPos(Hndl, IntPtr.Zero, 10, 10, 600,600, pin.User32.SetWindowPosFlags.SWP_SHOWWINDOW));
            Console.WriteLine(area.left);
            //System.Windows.Forms.MessageBox.Show("Pushback toggled");
            //pin.User32.MoveWindow(Hndl, 800, 800, 600, 600, true); // does not work on child window?
            //lblStatus.Text = "window" + " " + Hndl;

        }

        private void btnPushL_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.MessageBox.Show("Pushback Left");
        }

        private void btnPushR_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.MessageBox.Show("Pushback Right");
        }

        private void lblStatus_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.MessageBox.Show("Verify connection");
        }

        // User pressed connect button so try again...
        private void btnStart_Click(object sender, EventArgs e)
        {
            openFSUIPC();
            Console.WriteLine("click!");
        }

        // Opens FSUIPC - if all goes well then starts the 
        // timer to drive start the main application cycle.
        // If can't open display the error message.
        private void openFSUIPC()
        {
            try
            {
                // Attempt to open a connection to FSUIPC (running on any version of Flight Sim)
                FSUIPCConnection.Open();
                // Opened OK so disable the Connect button
                this.btnStart.Enabled = false;
            }
            catch (Exception ex)
            {
                // Badness occurred - show the error message
                MessageBox.Show(ex.Message, "AppTitle", MessageBoxButtons.OK, MessageBoxIcon.Error);
                FSUIPCConnection.Close();
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

    }
}
