using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public class WindowEnumTest
{
  public delegate bool CallBackEnumChildWin(IntPtr hWnd, IntPtr parameter);

  [DllImport("user32")]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool EnumChildWindows(IntPtr window, CallBackEnumChildWin callback, IntPtr i);

  public static List<IntPtr> GetChildWindows(IntPtr parent)
  {
    List<IntPtr> result = new List<IntPtr>();
    GCHandle listHandle = GCHandle.Alloc(result);
    try
    {
      CallBackEnumChildWin childProc = new CallBackEnumChildWin(EnumWindow);
      EnumChildWindows(parent, childProc, GCHandle.ToIntPtr(listHandle));
    }
    finally
    {
      if (listHandle.IsAllocated)
        listHandle.Free();
    }
    return result;
  }

  private static bool EnumWindow(IntPtr handle, IntPtr pointer)
  {
    GCHandle gch = GCHandle.FromIntPtr(pointer);
    List<IntPtr> list = gch.Target as List<IntPtr>;
    if (list == null)
      throw new InvalidCastException("GCHandle Target could not be cast as List<IntPtr>");

    list.Add(handle);
    return true;
  }

}