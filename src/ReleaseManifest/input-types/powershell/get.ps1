function Get-PowerShellModuleInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition,
        [Parameter(Mandatory, Position = 2)]
        [string]
        $Root
    )

    $ErrorActionPreference = "Stop"

    Install-Module `
        -Name $Definition.Name `
        -RequiredVersion $Definition.Version `
        -Repository $Definition.PSRepository `
        -Scope $Definition.Scopt `
        -Verbose 
}
Export-ModuleMember -Function Get-PowerShellModuleInput