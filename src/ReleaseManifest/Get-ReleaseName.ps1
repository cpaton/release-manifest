<#
.SYNOPSIS
Determines the name for a release based on its version and previous releases

.DESCRIPTION
Release names are primarily based on the application version.  The first release for a version
is named after that version directly.

If a patch is applied where the same application version is used but other release inputs are changed
e.g. configuration settings the release name is based on the application version with a suffix
#>
function Get-ReleaseName
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        # Primary version number for the release.  Typically the application binary version
        [Parameter(Mandatory)]
        [version]
        $Version,
        # Git repository used to store release manifests
        [Parameter(Mandatory)]
        [string]
        $GitRemote,
        # Prefix to be added to the tag in Git for the release.
        # The Git repository doesn't need to be available locally, all queries are made against the remote copy
        # Git does need to be configured to be able to query the remote e.g. with credentials
        [Parameter(Mandatory)]
        [string]
        $TagPrefix
    )

    $ErrorActionPreference = "Stop"

    # Releases are tagged as {prefix}{version}{optional revision}
    # e.g. release-0.40.13
    #      release-0.40.13-1
    #      release-0.40.14

    $releaseTagRefs = & $releaseManifestModule.Scripts.Exec "git ls-remote --refs --tags --quiet $GitRemote refs/tags/$TagPrefix*"
    $releaseTags = $releaseTagRefs | 
        ForEach-Object {
            ParseGitRef $_
        } |
        Where-Object { $_ } |
        ForEach-Object { $_.Ref -replace 'refs/tags/','' }

    $previousRelease = $null

    foreach ($releaseTag in $releaseTags)
    {
        $release = $null
        if ([Release]::TryParse($releaseTag, [ref]$release))
        {
            if ($release.IsBeforeOrSameVersion($Version) -and ((-not $previousRelease) -or $release.IsAfterRelease($previousRelease)))
            {
                $previousRelease = $release
            }
        }
    }

    if (-not $previousRelease)
    {
        $newRelease = [Release]::new($Version, 0)
        @{
            PreviousRelease = $null
            Release = $newRelease.ToString()
        }
    }
    else
    {
        $newRelease = $previousRelease.Next($Version)
        @{
            PreviousRelease = $previousRelease.ToString()
            Release = $newRelease.ToString()
        }
    }
}
Export-ModuleMember -Function Get-ReleaseName