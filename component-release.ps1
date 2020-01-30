[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]
    $Name,
    [Parameter()]
    [string]
    $ComponentRef = $('master')
)

$ErrorActionPreference = "Stop"

$generateRelease = Join-Path $PSScriptRoot "generate-release.ps1"
$git = Join-Path $PSScriptRoot "types/git/create.ps1"
$maven = Join-Path $PSScriptRoot "types/maven/create.ps1"
$goldenImage = Join-Path $PSScriptRoot "types/golden-image/create.ps1"

& $generateRelease $Name {
    [ordered]@{
        AMI = @(
            & $git notebook file:///_cp/Git/notebook master
            & $git powershell file:///_cp/Git/PowerShell 2a37b01860cabf5834b87e615887231f31ef5eea
            & $maven component com.company component 0.40.13
            & $goldenImage AmazonLinux2
        )
        Deployment = @(
            & $git notebook file:///_cp/Git/notebook master
            & $git aws-cdk file:///_cp/Git/aws-cdk v1.5.0
        )
    }
}