using System;



public delegate bool EnumWindowProc(IntPtr hWnd, IntPtr parameter);

[DllImport("user32")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool EnumChildWindows(IntPtr window, EnumWindowProc callback, IntPtr i);

public static List<IntPtr> GetChildWindows(IntPtr parent)
{
    List<IntPtr> result = new List<IntPtr>();
    GCHandle listHandle = GCHandle.Alloc(result);
    try
    {
        EnumWindowProc childProc = new EnumWindowProc(EnumWindow);
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



[DllImport("user32.dll", CharSet = CharSet.Auto)]
public static extern int GetWindowTextLength(HandleRef hWnd);
[DllImport("user32.dll", CharSet = CharSet.Auto)]
public static extern int GetWindowText(HandleRef hWnd, StringBuilder lpString, int nMaxCount);

//...
int capacity = GetWindowTextLength(new HandleRef(this, handle)) * 2;
StringBuilder stringBuilder = new StringBuilder(capacity);
     GetWindowText(new HandleRef(this, handle), stringBuilder, stringBuilder.Capacity);

