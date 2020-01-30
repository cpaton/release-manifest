[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    $ReleaseManifest,
    [Parameter(Mandatory)]
    [AllowNull()]
    [AllowEmptyString()]
    [string]
    $PreviousReleaseName,
    [Parameter(Mandatory)]
    [string]
    $Root,
    [Parameter(Mandatory)]
    [string]
    $TagPrefix,
    [Parameter(Mandatory)]
    [string]
    $GitRemote
)

$ErrorActionPreference = "Stop"
$exec = Join-Path $PSScriptRoot "exec.ps1"

$workingCopyPath = Join-Path $Root "release-repository"
if (Test-Path $workingCopyPath)
{
    Remove-Item -Path $workingCopyPath -Recurse -Force
}
New-Item -Path $workingCopyPath -ItemType Directory | Out-Null
Push-Location $workingCopyPath
try
{
    & $exec "git init ."
    & $exec "git remote add origin $GitRemote"

    if ([string]::IsNullOrWhiteSpace($PreviousReleaseName))
    {
        # Create empty branch
        $branchName = [Guid]::NewGuid().ToString()
        & $exec "git checkout --orphan $branchName"
        
        # # Delete temporary branch
        # & $exec "git checkout master"
        # & $exec "git branch --delete --force $branchName"
    }
    else
    {
        # Checkout the previous tag
        & $exec "git fetch --tags origin $TagPrefix$PreviousReleaseName"
        # & $exec "git checkout FETCH_HEAD"
        & $exec "git checkout $TagPrefix$PreviousReleaseName"
        
        # # Generate release manifest
        # $manifest = ConvertFrom-Json ( Get-Content ( Join-Path $PSScriptRoot "release.json" ) | Out-String )
        # $manifest.Key = [Guid]::NewGuid().ToString()
        # $manifest.Name = $ReleaseName
        # Set-Content -Path ( Join-Path $Path  "release.json" ) -Value ( ConvertTo-Json $manifest ) -Force

        # # Commit + Tag
        # $tagName = "release-$ReleaseName"
        # & $exec "git add ."
        # & $exec "git commit -m 'release $ReleaseName'"
        # & $exec "git tag --annotate '$tagName' --message '$tagName'"
        
        # # Push
        # & $exec "git push origin $tagName"

        # # Go back to master
        # & $exec "git checkout master"
    }

    # Generate release manifest
    Set-Content -Path "release.json" -Value ( ConvertTo-Json $ReleaseManifest | Out-String ) -Force

    # Commit + Tag
    $tagName = "$TagPrefix$($ReleaseManifest.Name)"
    & $exec "git add ."
    & $exec "git commit -m 'Release $($ReleaseManifest.Name)'"
    & $exec "git tag --annotate '$tagName' --message '$tagName'"
    
    # Push
    & $exec "git push origin $tagName"
}
finally
{
    Pop-Location
}