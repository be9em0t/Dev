using System;
using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using PInvoke;
using System.Diagnostics;
using DeskPilotForms2;

// --Done: list all running programs
// ToDo: list child windows
// ToDo: parse connected monitors and asign programs on startup ar on user command
// ToDo: create reasonable UI
// Done: create tray icon

// ToDo: Functionality
//      - ability to move any offscreen window inside of monitor frame
//      - Control on which monitor program windows appear (main window, child windows)
//      - Do something when a program window appears (move window depending on conditions, min/hide, move to screen, send message)
//      - Do something if program is not running
//      - Control for conditions (number of screens, running programs)
//        - Lower priority on overly agressive processes (i.e. Renderer)

// ToDo: UI Workflow
//      -    
//

namespace DeskPilotForms
{

  public partial class Form1 : Form
  {

    ArrayList topWinHandles = new ArrayList();

    //List<IntPtr> topWinHandleList = new List<IntPtr>();
    //ArrayList childWinHandles = new ArrayList();

    public Form1()
    {
      InitializeComponent();
      InitializeTreeView();
      notifyIcon1.Visible = false;
    }

    // button list all porcesses
    private void buttonListProc_Click(object sender, EventArgs e)
    {
      //listBox1TopWin.Items.Clear();
      //listBox2ChildWin.Items.Clear();
      Console.WriteLine("=============");

      InitializeTreeView();
      //InitializeTreeViewDemo();
    }


    //listBox1TopWin.BeginUpdate();
    //Process[] processlist = Process.GetProcesses();
    //foreach (Process process in processlist)
    //{
    //   if (!String.IsNullOrEmpty(process.MainWindowTitle))
    //   {
    //      topWinHandles.Add(process.MainWindowHandle);
    //      listBox1TopWin.Items.Add(process.ProcessName);
    //      //Console.WriteLine(process.ProcessName);
    //      List<IntPtr> childHands = WindowEnumTest.GetChildWindows(process.MainWindowHandle);
    //      Console.WriteLine(childHands.Count);
    //      foreach (IntPtr chHand in childHands)
    //      {
    //         Console.WriteLine(PinvokeMethods.GetText(chHand));
    //      }
    //   }
    //}
    //listBox1TopWin.EndUpdate();

    //      foreach (ProcessThread thread in process.Threads)
    //    PInvoke.User32.EnumThreadWindows(thread.Id, (hWnd, lParam) => { handles.Add(hWnd); return true; }, IntPtr.Zero);

    //return handles;

    private void InitializeTreeView()
    {
      treeViewWin.Nodes.Clear();
      treeViewWin.BeginUpdate();
      //Process[] processlist = Process.GetProcesses();
      List<IntPtr> rootWinHands = WindowEnumTest.GetChildWindows(IntPtr.Zero);

      //foreach (Process process in processlist)
      foreach (IntPtr rootHand in rootWinHands)
      {
        //if (!String.IsNullOrEmpty(process.MainWindowTitle))
        string rootWindowText = PinvokeMethods.GetText(rootHand);

        if (!String.IsNullOrEmpty(PinvokeMethods.GetText(rootHand)))
        {
          TreeNode tn = new TreeNode();
          //tn.Text = process.MainWindowTitle;
          //tn.Tag = process.MainWindowHandle;
          tn.Text = rootWindowText;
          tn.Tag = rootHand;
          treeViewWin.Nodes.Add(tn);

          //List<IntPtr> childHands = WindowEnumTest.GetChildWindows(process.MainWindowHandle);
          List<IntPtr> childHands = WindowEnumTest.GetChildWindows(rootHand);
          //PinvokeMethods.EnumWindowsAll();

          //Console.WriteLine(childHands.Count);
          foreach (IntPtr chHand in childHands)
          {
            TreeNode tnc = new TreeNode();
            string chWindowText = PinvokeMethods.GetText(chHand);
            tnc.Text = chWindowText;
            tnc.Tag = chHand;
            treeViewWin.Nodes[tn.Index].Nodes.Add(tnc);

            //if (PinvokeMethods.IsVisible(chHand) == true || chWindowText != "")
            //{
            //  tnc.Text = chWindowText;
            //  tnc.Tag = chHand;
            //  treeViewWin.Nodes[tn.Index].Nodes.Add(tnc);
            //  Console.WriteLine(tn.Level + " : " + tn.Index + " : " + PinvokeMethods.GetText(chHand));
            //}
          }

          //PrintChildren();

        }
      }
      treeViewWin.EndUpdate();

      //PrintWinList();

    }

    private void PrintChildren()
    {
      Console.WriteLine("print children");
      //try
      //{
      //  //IntPtr childHand = PInvoke.User32.FindWindowEx(IntPtr.Zero, IntPtr.Zero, null, null);
      //  //Debug.WriteLine(childHand);
      //  //listBox2.Items.Add(listBox1.SelectedIndex);
      //}
      //catch
      //{
      //  Debug.WriteLine("error");
      //}
    }

    private void PrintRecursive(TreeNode treeNode)
    {
      Console.WriteLine(treeNode.Level + " : " + treeNode.Parent + " : " + treeNode.Text + " : " + treeNode.Name);
      foreach (TreeNode tn in treeNode.Nodes)
      {
        PrintRecursive(tn);
      }

    }

    private void PrintWinList()
    {
      TreeNodeCollection treeWin = treeViewWin.Nodes;
      foreach (TreeNode n in treeWin)
      {
        PrintRecursive(n);
      }
    }

    private void InitializeTreeViewDemo()
    {
      treeViewWin.BeginUpdate();
      treeViewWin.Nodes.Add("Parent");
      treeViewWin.Nodes[0].Nodes.Add("Child 1");
      treeViewWin.Nodes[0].Nodes.Add("Child 2");
      treeViewWin.Nodes[0].Nodes[1].Nodes.Add("Grandchild");
      treeViewWin.Nodes[0].Nodes[1].Nodes[0].Nodes.Add("Great Grandchild");
      treeViewWin.Nodes[0].Nodes[0].Nodes.Add("Grandchild1");
      treeViewWin.Nodes[0].Nodes[0].Nodes[0].Nodes.Add("Grandchild2");
      treeViewWin.EndUpdate();
    }

    // ======== uncleaned ===========

    //IntPtr hand = process.MainWindowHandle; // PInvoke.User32.FindWindow("XYZ_Widget_1", null);
    //if (hand != null)
    //{
    //    hand = PInvoke.User32.FindWindowEx(hand, IntPtr.Zero, null, null);
    //    if (hand != null)
    //    {
    //        //Console.WriteLine("child: " + hand + " : " + PInvoke.User32.IsWindow(hand));
    //        if (PInvoke.User32.IsWindow(hand) == true)
    //        {
    //            Console.WriteLine("child: " + hand + " : ");
    //        }
    //        //hand = PInvoke.User32.FindWindowEx(hand, IntPtr.Zero, "XYZ_Renderer", null);
    //        // and so on... 
    //    }
    //}




    public IntPtr findWin()
    {
      // Get window handle
      IntPtr winHandle = PInvoke.User32.FindWindow("Notepad", "Untitled - Notepad");
      return winHandle;
    }

    // button test notepad
    private void button1_Click(object sender, EventArgs e)
    {
      IntPtr winHandle = findWin();

      // Position and active window
      PInvoke.User32.MoveWindow(winHandle, 10, 10, 500, 500, true);
      PInvoke.User32.ShowWindow(winHandle, User32.WindowShowStyle.SW_SHOWNORMAL);
      PInvoke.User32.SetForegroundWindow(winHandle);
    }

    private void listBox1_DoubleClick(object sender, EventArgs e)
    {
      Debug.WriteLine(listBox1TopWin.SelectedItem);
      //try
      //{
      //    IntPtr childHand = PInvoke.User32.FindWindowEx(IntPtr.Zero, IntPtr.Zero, null, null);
      //    Debug.WriteLine(childHand);
      //}
      //catch
      //{
      //    Debug.WriteLine("error");
      //}
    }

    private void listBox1_Click(object sender, EventArgs e)
    {

      listBox2ChildWin.Items.Clear();
      listBox2ChildWin.BeginUpdate();


      //IntPtr tmp = (IntPtr) topWinHandles[listBox1.SelectedIndex];
      //IntPtr childHand = PInvoke.User32.FindWindowEx(tmp, IntPtr.Zero, null, null);

      //var handles = new List<IntPtr>();

      //listBox2.Items.Add(childHand);

      //try
      //{
      //    IntPtr childHand = PInvoke.User32.FindWindowEx(IntPtr.Zero, IntPtr.Zero, null, null);
      //    //Debug.WriteLine(childHand);
      //    listBox2.Items.Add(listBox1.SelectedIndex);
      //}
      //catch
      //{
      //    Debug.WriteLine("error");
      //}

      listBox2ChildWin.EndUpdate();
    }

    // Traymin related
    private void Form1_Resize(object sender, EventArgs e)
    {
      notifyIcon1.BalloonTipTitle = "MinToTray";
      notifyIcon1.BalloonTipText = "it works!";

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

    // Tray icon related
    private void notifyIcon1_MouseClick(object sender, MouseEventArgs e)
    {
      this.Show();
      this.WindowState = FormWindowState.Normal;
    }


    private void button4_Click(object sender, EventArgs e)
    {
      PinvokeMethods.EnumWindowsMain();
      //ConsumeChildWins.MainMethAll();
    }

    private void treeViewWin_Click(object sender, EventArgs e)
    {
      Debug.WriteLine(treeViewWin.SelectedNode);
    }

    private void treeViewWin_DoubleClick(object sender, EventArgs e)
    {
      // Get the selected node.
      //
      TreeNode node = treeViewWin.SelectedNode;
      //
      // Render message box.
      //
      MessageBox.Show(string.Format("You selected: {0}", node.Text));
    }
  }
}
