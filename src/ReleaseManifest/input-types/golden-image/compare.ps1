function Compare-GoldenImageInput()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition,
        [Parameter(Mandatory, Position = 2)]
        $OtherDefinition
    )

    $ErrorActionPreference = "Stop"

    Compare-ReleaseInput $Definition $OtherDefinition Name,Type,AmiId
}
Export-ModuleMember -Function Compare-GoldenImageInput