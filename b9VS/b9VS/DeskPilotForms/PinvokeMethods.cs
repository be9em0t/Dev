using System;
using System.Runtime.InteropServices;
using System.Text;

namespace DeskPilotForms
{

  class PinvokeMethods
  {
    // Delegates
    public delegate bool CallBackEnumWin(int hwnd, int lParam);

    private delegate bool CallBackEnumChildWin(IntPtr hwnd, IntPtr lParam);

    // Signatures
    [DllImport("user32")]
    public static extern int EnumWindows(CallBackEnumWin x, int y);

    [DllImport("user32")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool EnumChildWindows(IntPtr window, CallBackEnumChildWin callback, IntPtr lParam);

    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

    [DllImport("user32.dll")]
    private static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

    [DllImport("psapi.dll")]
    private static extern uint GetModuleBaseName(IntPtr hWnd, IntPtr hModule, StringBuilder lpFileName, int nSize);

    [DllImport("psapi.dll")]
    private static extern uint GetModuleFileNameEx(IntPtr hWnd, IntPtr hModule, StringBuilder lpFileName, int nSize);

    [DllImport("kernel32.dll")]
    private static extern IntPtr OpenProcess(uint dwDesiredAccess, bool bInheritHandle, uint dwProcessId);

    [DllImport("kernel32.dll")]
    private static extern bool CloseHandle(IntPtr handle);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    static extern int GetWindowTextLength(IntPtr hWnd);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    static extern bool IsWindowVisible(IntPtr hWnd);

    // Enum and report all windows
    public static void EnumWindowsMain()
    {
      CallBackEnumWin myCallBack = new CallBackEnumWin(PinvokeMethods.EnumWindowsMainReport);
      EnumWindows(myCallBack, 0);
    }
    // Define callback function 
    public static bool EnumWindowsMainReport(int hwnd, int lParam)
    {
      Console.Write("Window handle is ");
      Console.WriteLine(hwnd);
      return true;
    }

    // Enum all windows
    public static void EnumWindowsAll()
    {
      CallBackEnumWin myCallBack = new CallBackEnumWin(PinvokeMethods.CallbackEnumWindowsAll);
      EnumWindows(myCallBack, 0);
    }
    public static bool CallbackEnumWindowsAll(int hwnd, int lParam)
    {
      IntPtr hnd = new IntPtr(hwnd);
      string hndWindowText = PinvokeMethods.GetText(hnd);
      if (PinvokeMethods.IsVisible(hnd) == true && hndWindowText != "")
      {
        Console.WriteLine("child : " + PinvokeMethods.GetText(hnd));
      }
      return true;
    }

    public static bool isIEServerWindow(IntPtr hWnd)
    {
      int nRet;
      // Pre-allocate 256 characters, since this is the maximum class name length.
      StringBuilder ClassName = new StringBuilder(256);
      //Get the window class name
      nRet = GetClassName(hWnd, ClassName, ClassName.Capacity);
      if (nRet != 0)
      {
        return (string.Compare(ClassName.ToString(), "Internet Explorer_Server", true, System.Globalization.CultureInfo.InvariantCulture) == 0);
      }
      else
      {
        return false;
      }
    }

    public static void printClass(IntPtr hWnd)
    {
      int nRet;
      // Pre-allocate 256 characters, since this is the maximum class name length.
      StringBuilder ClassName = new StringBuilder(256);
      //Get the window class name
      nRet = GetClassName(hWnd, ClassName, ClassName.Capacity);
      Console.WriteLine(ClassName + " : " + nRet);
    }

    public static string GetTopWindowName()
    {
      IntPtr hWnd = GetForegroundWindow();
      uint lpdwProcessId;
      GetWindowThreadProcessId(hWnd, out lpdwProcessId);

      IntPtr hProcess = OpenProcess(0x0410, false, lpdwProcessId);

      StringBuilder text = new StringBuilder(1000);
      //GetModuleBaseName(hProcess, IntPtr.Zero, text, text.Capacity);
      GetModuleFileNameEx(hProcess, IntPtr.Zero, text, text.Capacity);

      CloseHandle(hProcess);

      return text.ToString();
    }

    // Get window text from handle
    public static string GetText(IntPtr hWnd)
    {
      // Allocate correct string length first
      int length = GetWindowTextLength(hWnd);
      StringBuilder sb = new StringBuilder(length + 1);
      GetWindowText(hWnd, sb, sb.Capacity);
      return sb.ToString();
    }

    // Check if handle of visible window
    public static bool IsVisible(IntPtr hWnd)
    {
      bool result = IsWindowVisible(hWnd);
      return result;
    }

  }

}
