class Release
{
    [version] $Version
    [int] $Revision

    Release([version] $version, [int] $revision)
    {
        $this.Version = $version
        $this.Revision = $revision
    }

    [bool] static TryParse([string] $value, [ref]$release)
    {
        if ($value -notmatch "(?<version>\d+\.\d+\.?\d*\.?\d*)(-(?<revision>\d+))?$")
        {
            $release.Value = $null
            return $false
        }

        $tagVersion = [version]::Parse($Matches['version'])
        $tagRevision = 0
        if ($Matches['revision'])
        {
            $tagRevision = [int]::Parse($Matches['revision'])
        }
        $release.Value = [Release]::new($tagVersion, $tagRevision)
        return $true
    }

    [string] ToString()
    {
        $releaseString = $this.Version.ToString()
        if ($this.Revision -gt 0)
        {
            $releaseString += "-$($this.Revision)"
        }
        return $releaseString
    }

    [bool] IsBeforeOrSameVersion([version]$other)
    {
        if ($null -eq $other)
        {
            return $true
        }
        $versionComparison = $this.Version.CompareTo($other)
        return $versionComparison -le 0
    }

    [bool] IsBeforeRelease([Release]$other)
    {
        if ($null -eq $other)
        {
            return $true
        }

        $versionComparison = $this.Version.CompareTo($other.Version)
        if ($versionComparison -lt 0)
        {
            return $true
        }
        if ($versionComparison -gt 0)
        {
            return $false
        }
        return $this.Revision -lt $other.Revision        
    }

    [bool] IsAfterRelease([Release]$other)
    {
        return -not $this.IsBeforeRelease($other)        
    }

    [Release] Next([version]$version)
    {
        if ($this.Version -eq $version)
        {
            return [Release]::new($version, $this.Revision + 1)
        }
        return [Release]::new($version, 0)
    }
}