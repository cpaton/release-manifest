function Compare-SingleReleaseInput()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition,
        [Parameter(Mandatory, Position = 2)]
        $OtherDefinition,
        [Parameter(Mandatory, Position = 3)]
        [string[]]
        $Properties
    )

    $ErrorActionPreference = "Stop"

    if ($null -eq $Definition -or $null -eq $OtherDefinition)
    {
        return $false
    }

    foreach ($property in $Properties)
    {
        if ($Definition.$property -ne $OtherDefinition.$property)
        {
            return $false
        }
    }

    return $true
}