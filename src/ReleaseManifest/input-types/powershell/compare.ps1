function Compare-PowerShellModuleInput()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition,
        [Parameter(Mandatory, Position = 2)]
        $OtherDefinition
    )

    $ErrorActionPreference = "Stop"

    Compare-ReleaseInput $Definition $OtherDefinition Name,Type,PSRepository,ModuleName,Version
}
Export-ModuleMember -Function Compare-PowerShellModuleInput