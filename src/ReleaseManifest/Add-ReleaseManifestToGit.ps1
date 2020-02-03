function Add-ReleaseManifestToGit
{
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

    $workingCopyPath = Join-Path $Root "release-repository"
    if (Test-Path $workingCopyPath)
    {
        Remove-Item -Path $workingCopyPath -Recurse -Force
    }
    New-Item -Path $workingCopyPath -ItemType Directory | Out-Null
    Push-Location $workingCopyPath
    try
    {
        & $releaseManifestModule.Scripts.Exec "git init ."
        & $releaseManifestModule.Scripts.Exec "git remote add origin $GitRemote"

        if ([string]::IsNullOrWhiteSpace($PreviousReleaseName))
        {
            # Create empty branch
            $branchName = [Guid]::NewGuid().ToString()
            & $releaseManifestModule.Scripts.Exec "git checkout --orphan $branchName"
            
            # # Delete temporary branch
            # & $releaseManifestModule.Scripts.Exec "git checkout master"
            # & $releaseManifestModule.Scripts.Exec "git branch --delete --force $branchName"
        }
        else
        {
            # Checkout the previous tag
            & $releaseManifestModule.Scripts.Exec "git fetch --tags origin $TagPrefix$PreviousReleaseName"
            # & $releaseManifestModule.Scripts.Exec "git checkout FETCH_HEAD"
            & $releaseManifestModule.Scripts.Exec "git checkout $TagPrefix$PreviousReleaseName"
            
            # # Generate release manifest
            # $manifest = ConvertFrom-Json ( Get-Content ( Join-Path $PSScriptRoot "release.json" ) | Out-String )
            # $manifest.Key = [Guid]::NewGuid().ToString()
            # $manifest.Name = $ReleaseName
            # Set-Content -Path ( Join-Path $Path  "release.json" ) -Value ( ConvertTo-Json $manifest ) -Force

            # # Commit + Tag
            # $tagName = "release-$ReleaseName"
            # & $releaseManifestModule.Scripts.Exec "git add ."
            # & $releaseManifestModule.Scripts.Exec "git commit -m 'release $ReleaseName'"
            # & $releaseManifestModule.Scripts.Exec "git tag --annotate '$tagName' --message '$tagName'"
            
            # # Push
            # & $releaseManifestModule.Scripts.Exec "git push origin $tagName"

            # # Go back to master
            # & $releaseManifestModule.Scripts.Exec "git checkout master"
        }

        # Generate release manifest
        Set-Content -Path "release.json" -Value ( ConvertTo-Json $ReleaseManifest | Out-String ) -Force

        # Commit + Tag
        $tagName = "$TagPrefix$($ReleaseManifest.Name)"
        & $releaseManifestModule.Scripts.Exec "git add ."
        & $releaseManifestModule.Scripts.Exec "git commit -m 'Release $($ReleaseManifest.Name)'"
        & $releaseManifestModule.Scripts.Exec "git tag --annotate '$tagName' --message '$tagName'"
        
        # Push
        & $releaseManifestModule.Scripts.Exec "git push origin $tagName"
    }
    finally
    {
        Pop-Location
    }
}
Export-ModuleMember -Function Add-ReleaseManifestToGit