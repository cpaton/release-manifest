[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $ReleaseManifestPath = $("/data/release.json")
)

$ErrorActionPreference = "Stop"

$outputRoot = Join-Path $PSScriptRoot ".build"
$releaseManifest = ConvertFrom-Json (Get-Content -Path $ReleaseManifestPath | Out-String)

$namedItems = @( 'AMI', 'Deployment')
foreach ($item in $namedItems)
{
    $manifestItem = $releaseManifest.$item
    $itemPath = Join-Path $outputRoot $item

    if (Test-Path $itemPath)
    {
        Remove-Item -Path $itemPath -Force -Recurse
    }
    New-Item -Path $itemPath -ItemType Directory | Out-Null

    foreach ($input in $manifestItem)
    {
        Write-Host "Processing $($input.Name)..."

        $typeFolder = Join-Path $PSScriptRoot "types\$($input.Type)"
        $get = Join-Path $typeFolder "get.ps1"

        & $get $input $itemPath
    }
}