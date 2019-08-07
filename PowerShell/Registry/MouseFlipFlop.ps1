# This script sets all mice to natural scroll.
Get-ChildItem -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID' -Recurse -ErrorAction:SilentlyContinue | foreach { if((get-itemproperty -Path $_.PsPath) -match "FlipFlopWheel") { Set-ItemProperty -Path $_.PsPath -name FlipFlopWheel -Value '1'} }
