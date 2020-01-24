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
    Type = "maven"
    Group = $Group
    ArtifactId = $Artifact
    Version = $Version
}