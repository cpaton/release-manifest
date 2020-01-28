[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]
    $ReleaseName,
    [Parameter(Mandatory)]
    [AllowNull()]
    [AllowEmptyString()]
    [string]
    $PreviousReleaseName,
    [Parameter()]
    [string]
    $Path = $("C:\_cp\Git\component")
)

$ErrorActionPreference = "Stop"
$exec = Join-Path $PSScriptRoot "exec.ps1"

Push-Location $Path
try
{
    if ([string]::IsNullOrWhiteSpace($PreviousReleaseName))
    {
        # Create empty branch
        $branchName = [Guid]::NewGuid().ToString()
        & $exec "git checkout --orphan $branchName"
        
        # Generate release manifest
        Copy-Item -Path ( Join-Path $PSScriptRoot "release.json" ) -Destination .

        # Commit + Tag
        $tagName = "release-$ReleaseName"
        & $exec "git add ."
        & $exec "git commit -m 'release $ReleaseName'"
        & $exec "git tag --annotate '$tagName' --message '$tagName'"
        
        # Push
        & $exec "git push origin $tagName"

        # Delete temporary branch
        & $exec "git checkout master"
        & $exec "git branch --delete --force $branchName"
    }
    else
    {
        # Checkout the previous tag
        & $exec "git checkout 'release-$PreviousReleaseName'"
        
        # Generate release manifest
        $manifest = ConvertFrom-Json ( Get-Content ( Join-Path $PSScriptRoot "release.json" ) | Out-String )
        $manifest.Key = [Guid]::NewGuid().ToString()
        $manifest.Name = $ReleaseName
        Set-Content -Path ( Join-Path $Path  "release.json" ) -Value ( ConvertTo-Json $manifest ) -Force

        # Commit + Tag
        $tagName = "release-$ReleaseName"
        & $exec "git add ."
        & $exec "git commit -m 'release $ReleaseName'"
        & $exec "git tag --annotate '$tagName' --message '$tagName'"
        
        # Push
        & $exec "git push origin $tagName"

        # Go back to master
        & $exec "git checkout master"
    }
}
finally
{
    Pop-Location
}