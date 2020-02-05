function New-MavenInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [string]
        $Name,
        [Parameter(Mandatory, Position = 2)]
        [string]
        $Group,
        [Parameter(Mandatory, Position = 3)]
        [string]
        $Artifact,
        [Parameter(Mandatory, Position = 4)]
        [string]
        $Version
    )

    [ordered] @{
        Name = $Name
        Type = "Maven"
        Group = $Group
        ArtifactId = $Artifact
        Version = $Version
    }
}
Export-ModuleMember -Function New-MavenInput