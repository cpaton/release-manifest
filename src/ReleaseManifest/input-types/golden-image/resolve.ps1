function Resolve-GoldenImageInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition    
    )

    $ErrorActionPreference = "Stop"
}
Export-ModuleMember -Function Resolve-GoldenImageInput