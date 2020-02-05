function Resolve-MavenInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition    
    )
}
Export-ModuleMember -Function Resolve-MavenInput