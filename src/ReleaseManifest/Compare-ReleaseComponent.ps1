function Compare-ReleaseComponent
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $ReleaseManifest,
        [Parameter(Mandatory, Position = 2)]
        $OtherReleaseManifest,
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