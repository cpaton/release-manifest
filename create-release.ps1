#! /usr/bin/env pwsh

[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $AppVersion
)

$ErrorActionPreference = "Stop"

# Handle running on windows to copy the .ssh configuration into Linux with correct permissions
New-Item -Path /root/.ssh -ItemType Directory | Out-Null
cp -R /.ssh /root
chmod 600 -R /root/.ssh
# ls -la /root/.ssh

$modulePath = Join-Path $PSScriptRoot "src/ReleaseManifest/ReleaseManifest.psd1"
Import-Module -Name $modulePath

# c:\_cp -> /_c
# /data
# /data/module -> this code
# /data/get-release -> get previous release details
# /data/publish-release -> repository for publishing

$releaseRepositoryRemote = 'file:///_cp/Git/component-repo'
$releaseTagPrefix = "release-"


# Determine the new release name
$releaseNames = Get-ReleaseName -Version $AppVersion -Remote $releaseRepositoryRemote

# Get previous release details
# if ($releaseNames.PreviousRelease)
# {
#     $gitCreate = Join-Path $PSScriptRoot "types/git/create.ps1"
#     $gitResolve = Join-Path $PSScriptRoot "types/git/resolve.ps1"
#     $gitGet = Join-Path $PSScriptRoot "types/git/get.ps1"

#     $gitDetails = & $gitCreate get-release $releaseRepositoryRemote "$($releaseTagPrefix)$($releaseNames.PreviousRelease)"
#     & $gitResolve $gitDetails
#     & $gitGet $gitDetails /data

#     $previousReleaseManifest = ConvertFrom-Json ( Get-Content '/data/get-release/release.json' | Out-String )
#     $previousReleaseManifest | ConvertTo-Json
# }

# Generate the release.json file using name
$componentRelease = Join-Path $PSScriptRoot "component-release.ps1"
$releaseManifest = & $componentRelease -Name $releaseNames.Release
$releaseManifest | ConvertTo-Json

# Publish release manifest with tags
Add-ReleaseManifestToGit -ReleaseManifest $releaseManifest -PreviousReleaseName $releaseNames.PreviousRelease -Root /data -TagPrefix $releaseTagPrefix -GitRemote $releaseRepositoryRemote

# Get release