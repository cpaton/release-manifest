[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 1)]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 2)]
    [scriptblock]
    $InputGenerator
)

$release = [ordered]@{
    Key = [Guid]::NewGuid().ToString()
    Name = $Name
}

$Inputs = & $InputGenerator

foreach ($inputListName in $Inputs.Keys)
{
    foreach ($input in $Inputs[$inputListName])
    {
        $typeFolder = Join-Path $PSScriptRoot "types\$($input.Type)"
        $resovle = Join-Path $typeFolder "resolve.ps1"

        & $resovle $input
    }

    $release[$inputListName] = $Inputs[$inputListName]
}

$release

# $releaseJson = ConvertTo-Json $release
# Set-Content -Path /data/release.json -Value $releaseJson


