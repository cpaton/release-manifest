function New-GitInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [string]
        $Name,
        [Parameter(Mandatory, Position = 2)]
        [string]
        $Remote,
        [Parameter(Mandatory, Position = 3)]
        [string]
        $GitRef
    )

    [ordered]@{
        Name = $Name
        Type = "Git"
        Remote = $Remote
        Ref = $GitRef
    }
}
Export-ModuleMember -Function New-GitInput