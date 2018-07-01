$skip = "320x240", "2dsource"
$use = "320x240"
$filesToMove = Get-ChildItem "320x240"
if ($filesToMove.Length -gt 0) {dir $use}

exit

if ($filesToMove.Length -gt 0) {mkdir "320x240"}
ForEach-Object -InputObject $filesToMove {Move-Item $_.Name "320x240"}
