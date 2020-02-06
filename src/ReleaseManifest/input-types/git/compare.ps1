function Compare-GitInput()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition,
        [Parameter(Mandatory, Position = 2)]
        $OtherDefinition
    )

    $ErrorActionPreference = "Stop"

    Compare-ReleaseInput $Definition $OtherDefinition Name,Type,Remote,CommitId
}
Export-ModuleMember -Function Compare-GitInput