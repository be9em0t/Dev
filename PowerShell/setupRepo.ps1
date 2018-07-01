# Create and init Remote and Local GIT repo
# Syntax: setupRepo 'repoName' 'remote bare repo parent dir' ' local repo parent dir'
# Install-Module posh-git -Scope CurrentUser

param (
    [string]$repoName = $( Read-Host "`nInput Repository NAME"),
    [string]$remoteRepo = $( Read-Host "`nInput REMOTE Repository parent dir (ENTER for default)" ),
    [string]$localRepo = $( Read-Host "`nInput LOCAL Repository parent dir" )
	 )

# Enable verbose mode
Set-PSDebug -Trace 0

#global vars
[bool]$literalDirs = $false
[string]$defaultRemote = '\\brix\e\OneDrive\WolandShare\~GIT\'

#test for Repo dir sanity	
if(!($remoteRepo)) { 
	$remoteRepo = $defaultRemote
	Write-Host "`nUsing $defaultRemote as Remote Repo.`n" -foreground "white" -backgroundcolor "green"
		}
if(!($localRepo)) { 
	Write-Host "`nYou must supply Remote and Local Repository locations. Bye.`n" -foreground "white" -backgroundcolor "red"
	Exit
		}
		
#test if we have repoName
if($repoName)
    {
	Write-Host ("`n Repository name will be: " + $repoName + " `n") -foreground "white" -backgroundcolor "DarkGray"
    }
else {
	Write-Host ("`nDo you want to use Remote and Local as target forders? (Yes/No)`n") -foreground "white" -backgroundcolor "DarkGray"
	$response = Read-Host
		if (($response -eq "y") -or ($response -eq "yes")) {
		        $literalDirs = $true
		    }
		else{ 
			Write-Host ("Cancelled. Bye") -foreground "white" -backgroundcolor "red"
			Exit
			}
	}

# test that repo folders exist
if(!(Test-Path -path $remoteRepo))
    {
	Write-Host ("`nRemote Repository dir: " + $remoteRepo + " does not exist. Bye.") -foreground "white" -backgroundcolor "red"
	Exit
    }
elseif(!(Test-Path -path $localRepo))
    {
	Write-Host ("`nRemote Repository dir: " + $localRepo+ " does not exist. Bye.") -foreground "white" -backgroundcolor "red"
	Exit
    }
# create repositories
else {
#	write-Host ("`nRepo Directories OK.`n") -foreground "white" -backgroundcolor "green"
	# create repositories: Repo Name NOT supplied - using directly dir names 
	if ($literalDirs -eq $true) {
		$remoteRepo = $remoteRepo.TrimEnd('\')
		$localRepo = $localRepo.TrimEnd('\')		
		Write-Host $remoteRepo
		Write-Host $localRepo
		git init $remoteRepo --bare --shared | Out-Null
		Invoke-Item $remoteRepo #open in Explorer

		git init $localRepo | Out-Null
#		Start-Sleep -s 10
		Set-Location -Path $localRepo
		git remote add origin $remoteRepo
		$source =$PSScriptRoot  + '\.gitattributes' 
		$target = $localRepo.TrimEnd('\') + '\.gitattributes'
		Copy-Item $source $target
		$source =$PSScriptRoot  + '\.gitignore' 
		$target = $localRepo.TrimEnd('\') + '\.gitignore'
		Copy-Item $source $target
		Invoke-Item $localRepo		#open in Explorer
		}
	# create repositories: Repo Name supplied - creating repo inside parent directories
	elseif ($literalDirs -eq $false) {
		$remoteRepo = ($remoteRepo + $repoName).TrimEnd('\')
		$localRepo = ($localRepo + $repoName).TrimEnd('\')		
		git init $remoteRepo --bare --shared | Out-Null
		Invoke-Item $remoteRepo #open in Explorer

		git init $localRepo | Out-Null
#		Start-Sleep -s 10
		Set-Location -Path $localRepo
		git remote add origin $remoteRepo
		$source =$PSScriptRoot  + '\.gitattributes' 
		$target = $localRepo.TrimEnd('\') + '\.gitattributes'
		Copy-Item $source $target
		$source =$PSScriptRoot  + '\.gitignore' 
		$target = $localRepo.TrimEnd('\') + '\.gitignore'
		Copy-Item $source $target
		Invoke-Item $localRepo		#open in Explorer
		
		}
	else {
		Write-Host "Serious fuckup appears to be."
		Exit
		}
}

# Start-Process $target
# Start-Process $file -wait

