<#
.SYNOPSIS
Compares a single input to see if it is identical to another input

.DESCRIPTION
Typically used when comparing all inputs to a component to see if the component is identical

Two inputs are considered the same if they are both not null and if the specified properties match exactly
#>
function Compare-ReleaseInput()
{
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        # New input definition
        [Parameter(Mandatory, Position = 1)]
        $Definition,
        # Previous input definition
        [Parameter(Mandatory, Position = 2)]
        $OtherDefinition,
        # Properties to compare on the definition
        [Parameter(Mandatory, Position = 3)]
        [string[]]
        $Properties
    )

    $ErrorActionPreference = "Stop"

    if ($null -eq $Definition -or $null -eq $OtherDefinition)
    {
        Write-Verbose "Definition is null $($null -eq $Definition) / $($null -eq $OtherDefinition)"
        return $false
    }

    foreach ($property in $Properties)
    {
        if ($Definition.$property -ne $OtherDefinition.$property)
        {
            Write-Verbose "Property $property doesn't match $($Definition.$property) != $($OtherDefinition.$property)"
            return $false
        }
    }

    return $true
}