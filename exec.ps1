[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 1)]
    [string]
    $Command,
    [Parameter(Position = 2)]
    [string]
    $Description
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrEmpty($Description))
{
    $Description = $Command
}

Write-Verbose $Command
Invoke-Expression $Command

$exitCode = $LASTEXITCODE
if ($exitCode -ne 0)
{
    Write-Host $Command
    throw "$Description failed with exit code $exitCode"
}