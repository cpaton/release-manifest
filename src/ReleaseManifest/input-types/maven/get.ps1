function Get-MavenInput
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
}
Export-ModuleMember -Function Get-MavenInput