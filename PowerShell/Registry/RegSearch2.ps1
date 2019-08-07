# $RegKey = (Get-ItemProperty 'HKCU:\Control Panel')

# $RegKey = (Get-ChildItem -Path hklm:\SYSTEM\CurrentControlSet\Enum\HID\* -Include *VHF)

Get-ChildItem -Path hklm:\SYSTEM\CurrentControlSet\Enum\HID\* -Recurse | ForEach-Object { Split-Path $_.FullName -Parent }

Get-help -Category

1000, 2000, 3000 | ForEach-Object -Process { $_ / 1000 }

"Microsoft.PowerShell.Core", "Microsoft.PowerShell.Host" | ForEach-Object { $_.Split(".") }

Get-ChildItem -Path 'hklm:\SYSTEM\CurrentControlSet\Enum\HID\MSHW0125&Col01\' -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }


Get-Item -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID\MSHW0125&Col01\5&17ee1073&0&0000' |
Select-Object -ExpandProperty Property

#---- 

Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID\MSHW0125&Col01\5&17ee1073&0&0000' -name Test

Rename-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID\MSHW0125&Col01\5&17ee1073&0&0000' -name Test -NewName TestNew

Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID\MSHW0125&Col01\5&17ee1073&0&0000' -name TestNew -Value 'val'

# $RegKey.PSObject.Properties | ForEach-Object {
#     Write-Host $_.Name ' = ' $_.Value
#   }


Get-ChildItem -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID' -Recurse -ErrorAction:SilentlyContinue 

Get-ChildItem -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID' -Recurse -ErrorAction:SilentlyContinue | Write-Host $_.PSPath

Get-ChildItem -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\HID' -Recurse -ErrorAction:SilentlyContinue | foreach { if((get-itemproperty -Path $_.PsPath) -match "FlipFlopWheel") { $_.PsPath} }

# $RegKey.PSObject.Properties | ForEach-Object {
#   If($_.Name -like '*View*'){
#     Write-Host $_.Name ' = ' $_.Value
#   }
# }