<#
.SYNOPSIS
Commits a release manifest into a Git repository

.DESCRIPTION
To allow for easy comparison the new release manifest is committed as a change
on top of the previous release if provided.

Git is tagged with the name of the release

Note as commits are made to Git, Git needs to be configured with author and committer details
either through git configuration of environment variables.  Changes are also pushed so
credentials/configuration must also be available to push to the remote
#>
function Add-ReleaseManifestToGit
{
    [CmdletBinding()]
    param(
        # Full release manifest that wil be converted to JSON and written to Git
        [Parameter(Mandatory)]
        $ReleaseManifest,
        # Name of the release that proceeds this one.
        # If specified this new release is commited as a chnage on top of that release
        # If not specified the commit is made on top of an empty branch
        [Parameter(Mandatory)]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $PreviousReleaseName,
        # Directory under which the Git repository can be temporarily checked out i.e. the working area for this script
        [Parameter(Mandatory)]
        [string]
        $Root,
        # Prefix to be added to the tag in Git for the release.
        [Parameter(Mandatory)]
        [string]
        $TagPrefix,
        # Git repository to add the manifest to
        [Parameter(Mandatory)]
        [string]
        $GitRemote
    )

    $ErrorActionPreference = "Stop"

    # Start with a fresh working directory for working with Git
    $workingCopyPath = Join-Path $Root "release-repository"
    if (Test-Path $workingCopyPath)
    {
        Remove-Item -Path $workingCopyPath -Recurse -Force
    }
    New-Item -Path $workingCopyPath -ItemType Directory | Out-Null
    
    Push-Location $workingCopyPath
    try
    {
        # Setup the working copy with the specified remote
        & $releaseManifestModule.Scripts.Exec "git init ."
        & $releaseManifestModule.Scripts.Exec "git remote add origin $GitRemote"

        if ([string]::IsNullOrWhiteSpace($PreviousReleaseName))
        {
            # Can't commit on top of existing release so create empty branch
            $branchName = [Guid]::NewGuid().ToString()
            & $releaseManifestModule.Scripts.Exec "git checkout --orphan $branchName"
        }
        else
        {
            # Checkout the previous release tag
            & $releaseManifestModule.Scripts.Exec "git fetch --tags origin $TagPrefix$PreviousReleaseName"
            & $releaseManifestModule.Scripts.Exec "git checkout $TagPrefix$PreviousReleaseName"
        }

        # Generate release manifest
        Set-Content -Path "release.json" -Value ( ConvertTo-Json $ReleaseManifest -Depth 20 | Out-String ) -Force

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