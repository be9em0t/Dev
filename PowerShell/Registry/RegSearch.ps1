# #==Execution policy===
# powershell -ExecutionPolicy ByPass -File script.ps1

# if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# $command = "dir 'c:\program files' "
# powershell -Command $command


# $arg = "reg.exe Add 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers' /v  'c:\Ketarin\Tools\PowerPro\powerpro.exe' /d '~ RUNASADMIN'; pause"
# Start-Process -FilePath powershell -ArgumentList $arg -Verb RunAs


# Write-Host "Hello world1"
# "Hello World2"
# Out-Host -InputObject "Hello World3"

# if(@(Get-ChildItem HKLM: -Recurse |Where-Object {$_.PSChildName -eq 'RebootRequired'}))
# {
#   # Something was returned! Create the file
#   New-Item C:\Candi\RebootRequired.txt -ItemType File
# }

# if(@(Get-ChildItem HKLM: -Recurse |Where-Object {$_.PSChildName -eq 'Mouse'}))
# {
#   # Something was returned! Create the file
#   # New-Item C:\Candi\RebootRequired.txt -ItemType File
#   Write-Host "Hello world1"
# }

Test-Path -Path 'HKEY_CURRENT_USER\Control Panel\Mouse\'

cd HKCU:
Get-ChildItem 'AppEvents'

# $a = Test-Path -Path 'HKEY_CURRENT_USER\Control Panel\Mouse\'
# Write-Host $a
# if($a -eq $true){
#   #$a = true
#   Write-Host "true"
#   } else {
#   #a = false
#   Write-Host "false"
#   }