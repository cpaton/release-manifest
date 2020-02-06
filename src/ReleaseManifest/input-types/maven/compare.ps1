function Compare-MavenInput()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition,
        [Parameter(Mandatory, Position = 2)]
        $OtherDefinition
    )

    $ErrorActionPreference = "Stop"

    Compare-ReleaseInput $Definition $OtherDefinition Name,Type,Group,ArtifactId,Version
}
Export-ModuleMember -Function Compare-MavenInput