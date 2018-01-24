using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Diagnostics;


public class WindowHandleInfo
{
    private delegate bool CallBackEnumChildWin(IntPtr hwnd, IntPtr lParam);

    [DllImport("user32")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool EnumChildWindows(IntPtr window, CallBackEnumChildWin callback, IntPtr lParam);

    private IntPtr _MainHandle;

    public WindowHandleInfo(IntPtr handle)
    {
        this._MainHandle = handle;
    }

    public List<IntPtr> GetAllChildHandles()
    {
        List<IntPtr> childHandles = new List<IntPtr>();

        GCHandle gcChildhandlesList = GCHandle.Alloc(childHandles);
        IntPtr pointerChildHandlesList = GCHandle.ToIntPtr(gcChildhandlesList);

        try
        {
            CallBackEnumChildWin childProc = new CallBackEnumChildWin(EnumWindow);
            EnumChildWindows(this._MainHandle, childProc, pointerChildHandlesList);
        }
        finally
        {
            gcChildhandlesList.Free();
        }

        return childHandles;
    }

    private bool EnumWindow(IntPtr hWnd, IntPtr lParam)
    {
        GCHandle gcChildhandlesList = GCHandle.FromIntPtr(lParam);

        if (gcChildhandlesList == null || gcChildhandlesList.Target == null)
        {
            return false;
        }

        List<IntPtr> childHandles = gcChildhandlesList.Target as List<IntPtr>;
        childHandles.Add(hWnd);

        return true;
    }
}

public class ConsumeChildWins
{
    [DllImport("user32.dll", EntryPoint = "FindWindowEx")]
    public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);

    //public static void MainMeth(string[] args)
    public static void MainMeth()
    {
        Console.WriteLine("MainMeth");
        Process[] anotherApps = Process.GetProcesses(); //GetProcessesByName("powerpro");
        if (anotherApps.Length == 0) return;
        if (anotherApps[0] != null)
        {
            var allChildWindows = new WindowHandleInfo(anotherApps[0].MainWindowHandle).GetAllChildHandles();
        }
    }


    public static void MainMethAll()
    {
        Console.WriteLine("MainMethAll");
        Process[] anotherApps = Process.GetProcesses(); //GetProcessesByName("powerpro");

        foreach (Process process in anotherApps)
        {
            if (!String.IsNullOrEmpty(process.MainWindowTitle))
            {
                var allChildWindows = new WindowHandleInfo(process.MainWindowHandle).GetAllChildHandles();
                Console.WriteLine(allChildWindows);
            }
        }
    }

}


