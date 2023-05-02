﻿#--------------------------------
# Global Variables and Functions
#--------------------------------

function Get-Path()
{
	[OutputType([string])]
	param (
		[Parameter(Mandatory = $true)]
		[string]$RequestPath
	)
	
	$(((Get-Location).Path + '\Data\') + $RequestPath)
}

function Get-Icon()
{
	param (
		[Parameter(Mandatory = $true)]
		[String]$IconName
	)
	
	$(Get-Path -RequestPath ('Icons\' + $IconName + '.ico'))
}

function Enable-Feature()
{
	param (
		[Parameter(Mandatory = $true)]
		[String]$Feature
	)
	
	dism.exe /online /enable-feature /featurename:$FeatureName /all /norestart
	
}

function Parse-Wsl()
{
	param (
		[Parameter(Mandatory = $true)]
		[String]$Options
	)
	
	$collection = @()
	$expression = "wsl " + $Options
	
	((Invoke-Expression $expression | Select-Object -Skip 8) -replace "\x00", "") `
	| Where-Object { -not [string]::IsNullOrWhiteSpace($_) } `
	| ForEach-Object { $collection += ($_.Split(" ", [StringSplitOptions]::RemoveEmptyEntries)[0]) }
	
	$($collection)
}

function Get-State()
{
	$((Parse-Wsl -Options "-l").Count)
}


[System.Drawing.Icon]$Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($(Get-Icon -IconName "app"))
[System.Drawing.Size]$Size = New-Object System.Drawing.Size(1000, 500)

[String]$Title = "WSL2 Builder"