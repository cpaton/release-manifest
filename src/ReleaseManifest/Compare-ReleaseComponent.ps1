<#
.SYNOPSIS
Compares two release components to see if their inputs are identical

.DESCRIPTION
Typically used to determine if an existing release output can be re-used for a new release
The inputs to a component should define the output exactly and be deterministic.  If the inputs
are the same the output should be the same
#>
function Compare-ReleaseComponent
{
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        # New release manifest
        [Parameter(Mandatory, Position = 1)]
        $ReleaseManifest,
        # Previous release manifest
        [Parameter(Mandatory, Position = 2)]
        $OtherReleaseManifest,
        # Name of the component to compare
        [Parameter(Mandatory, Position = 3)]
        [string]
        $ComponentName
    )

    $ErrorActionPreference = "Stop"

    if ($null -eq $ReleaseManifest -or $null -eq $OtherReleaseManifest)
    {
        return $false
    } 

    $lhs = @($ReleaseManifest.Inputs.$ComponentName)
    $rhs = @($ReleaseManifest.Inputs.$ComponentName)

    if ($null -eq $lhs -or $null -eq $rhs)
    {
        return $false
    }

    # The component is an array of inputs
    if ($lhs.Length -ne $rhs.Length)
    {
        return $false
    }

    foreach ($lhsInput in $lhs)
    {
        $inputType = $lhsInput.Type
        $rhsInput = $rhs | Where-Object { $_.Name -eq $lhsInput.Name } | Select-Object -First 1

        if ($null -eq $rhsInput)
        {
            Write-Verbose "No equivalent '$($lhsInput.Name)' input found in RHS"
            return $false
        }

        $inputsEquivalent = & "Compare-$($inputType)Input" $lhsInput $rhsInput
        if (-not $inputsEquivalent)
        {
            Write-Verbose "Input '$($inputType.Name)' is different"
            return $false
        }
    }
    return $true
}
Export-ModuleMember -Function Compare-ReleaseComponent