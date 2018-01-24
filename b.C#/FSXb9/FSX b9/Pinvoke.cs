using System;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FSX_b9
{
    public static class Pinvoke
    {
        [DllImport("winmm.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern uint waveOutGetVolume(IntPtr hwo, uint dwVolume);

        [DllImport("msvcrt.dll")]
        public static extern int puts(string c);
        [DllImport("msvcrt.dll")]
        internal static extern int _flushall();

        public static void PinTest()
        {
            puts("Test");
            _flushall();
        }
    }
}
