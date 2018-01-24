using System;
using System.Runtime.InteropServices;
using System.Diagnostics;


public class WindowHandleInfo
{
    private delegate bool EnumWindowProc(IntPtr hwnd, IntPtr lParam);

    [DllImport("user32")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool EnumChildWindows(IntPtr window, EnumWindowProc callback, IntPtr lParam);

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
            EnumWindowProc childProc = new EnumWindowProc(EnumWindow);
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

    public static void MainMeth(string[] args)
    {
        Process[] anotherApps = Process.GetProcessesByName("powerpro");
        if (anotherApps.Length == 0) return;
        if (anotherApps[0] != null)
        {
            var allChildWindows = new WindowHandleInfo(anotherApps[0].MainWindowHandle).GetAllChildHandles();
        }
    }
}


