function Resolve-PowerShellModuleInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition    
    )

    $ErrorActionPreference = "Stop"

    if (-not [string]::IsNullOrEmpty($Definition.Version))
    {
        return
    }

    $module = Find-Module -Name $Definition.ModuleName -Repository $Definition.PSRepository -Verbose

    if ($module)
    {
        $Definition.Version = $module.Version
    }
}
Export-ModuleMember -Function Resolve-PowerShellModuleInput