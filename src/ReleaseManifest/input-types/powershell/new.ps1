function New-PowerShellModuleInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [string]
        $Name,
        [Parameter(Mandatory, Position = 2)]
        [string]
        $ModuleName,
        [Parameter(Position = 3)]
        [string]
        $PSRepository = $("PSGallery"),
        [Parameter(Position = 4)]
        [string]
        $Scope = $("CurrentUser")
    )

    [ordered]@{
        Name = $Name
        Type = "PowerShell"
        PSRepository = $PSRepository
        ModuleName = $ModuleName
        Scope = $Scope
    }
}
Export-ModuleMember -Function New-PowerShellModuleInput