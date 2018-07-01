$DaysBack = 2
$Today = Get-Date
$TempPaths = (Get-Item $env:TEMP), (Get-Item $env:TMP)

$TempPaths[0]

#(Get-ChildItem $TempPaths[0]).Length

ForEach-Object -InputObject $TempPaths -Process $_

# Get-ChildItem -Path -Recurse (Get-Item $env:TEMP)

