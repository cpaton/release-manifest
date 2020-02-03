function Get-ReleaseName
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter()]
        [version]
        $Version = $("0.40.13"),
        [Parameter()]
        [string]
        $Remote = $("file:///c/_cp/Git/component-repo")
    )

    $ErrorActionPreference = "Stop"
    $tagPrefix = "release-"

    # Releases are tagged as {prefix}{version}{optional revision}
    # e.g. release-0.40.13
    #      release-0.40.13-1
    #      release-0.40.14

    $releaseTagRefs = & $releaseManifestModule.Scripts.Exec "git ls-remote --refs --tags --quiet $Remote refs/tags/$tagPrefix*"
    $releaseTags = $releaseTagRefs | 
        ForEach-Object {
            ParseGitRef $_
        } |
        Where-Object { $_ } |
        ForEach-Object { $_.Ref -replace 'refs/tags/','' }

    # $releaseTags = @(
    #     '0.40.11',
    #     '0.40.13-2',
    #     '0.40.12',
    #     '0.40.13',
    #     '0.40.13-1',
    #     '0.40.15'
    # )

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