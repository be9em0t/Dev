/// <summary>
///     Copies the text of the specified window's title bar (if it has one) into a buffer. If the specified window is a
///     control, the text of the control is copied. However, GetWindowText cannot retrieve the text of a control in another
///     application.
///     <para>
///     Go to https://msdn.microsoft.com/en-us/library/windows/desktop/ms633520%28v=vs.85%29.aspx  for more
///     information
///     </para>
/// </summary>
/// <param name="hWnd">
///     C++ ( hWnd [in]. Type: HWND )<br />A <see cref="IntPtr" /> handle to the window or control containing the text.
/// </param>
/// <param name="lpString">
///     C++ ( lpString [out]. Type: LPTSTR )<br />The <see cref="StringBuilder" /> buffer that will receive the text. If
///     the string is as long or longer than the buffer, the string is truncated and terminated with a null character.
/// </param>
/// <param name="nMaxCount">
///     C++ ( nMaxCount [in]. Type: int )<br /> Should be equivalent to
///     <see cref="StringBuilder.Length" /> after call returns. The <see cref="int" /> maximum number of characters to copy
///     to the buffer, including the null character. If the text exceeds this limit, it is truncated.
/// </param>
/// <returns>
///     If the function succeeds, the return value is the length, in characters, of the copied string, not including
///     the terminating null character. If the window has no title bar or text, if the title bar is empty, or if the window
///     or control handle is invalid, the return value is zero. To get extended error information, call GetLastError.<br />
///     This function cannot retrieve the text of an edit control in another application.
/// </returns>
/// <remarks>
///     If the target window is owned by the current process, GetWindowText causes a WM_GETTEXT message to be sent to the
///     specified window or control. If the target window is owned by another process and has a caption, GetWindowText
///     retrieves the window caption text. If the window does not have a caption, the return value is a null string. This
///     behavior is by design. It allows applications to call GetWindowText without becoming unresponsive if the process
///     that owns the target window is not responding. However, if the target window is not responding and it belongs to
///     the calling application, GetWindowText will cause the calling application to become unresponsive. To retrieve the
///     text of a control in another process, send a WM_GETTEXT message directly instead of calling GetWindowText.<br />For
///     an example go to
///     <see cref="!:https://msdn.microsoft.com/en-us/library/windows/desktop/ms644928%28v=vs.85%29.aspx#sending">
///     Sending a
///     Message.
///     </see>
/// </remarks>
[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
