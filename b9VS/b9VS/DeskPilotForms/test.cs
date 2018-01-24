[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
static extern bool EnumChildWindows(IntPtr hwndParent, EnumWindowsProc lpEnumFunc, IntPtr lParam);

private List<IntPtr> GetChildWindows(IntPtr parent)  
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