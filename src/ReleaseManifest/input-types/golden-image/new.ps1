function New-GoldenImageInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [ValidateSet("AmazonLinux2", "WindowsServer2019")]
        [string]
        $ImageType,
        [Parameter(Position = 2)]
        [string]
        $Name = $('golden-image'),    
        [Parameter(Position = 3)]
        [string]
        $Ref = $('latest')
    )

    [ordered] @{
        Name = $Name
        Type = "GoldenImage"
        ImageType = $ImageType
        Ref = $Ref
    }
}
Export-ModuleMember -Function New-GoldenImageInput