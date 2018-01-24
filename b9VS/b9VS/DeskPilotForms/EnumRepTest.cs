using System;
using System.Runtime.InteropServices;

namespace DeskPilotForms2
{
    // Define delegate
    public delegate bool CallBack(int hwnd, int lParam);

    // wrapping class
    public static class EnumReportApp
    {
        // signature
        [DllImport("user32")]
        public static extern int EnumWindows(CallBack x, int y);

        // main function
        public static void Main1()
        {
            CallBack myCallBack = new CallBack(EnumReportApp.Report);
            EnumWindows(myCallBack, 0);
        }

        // Define function to execute on each enum
        public static bool Report(int hwnd, int lParam)
        {
            Console.Write("Window handle is ");
            Console.WriteLine(hwnd);
            return true;
        }

    }
}