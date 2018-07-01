$skip = "320x240", "2dsource"
$filesToMove = Get-ChildItem -Exclude $skip 
if ($filesToMove.Length -gt 0) {mkdir "320x240"}
ForEach-Object -InputObject $filesToMove {Move-Item $_.Name "320x240"}
