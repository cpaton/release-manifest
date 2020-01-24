[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $Generate,
    [Parameter()]
    [switch]
    $Get
)

if ($Generate)
{
    $dockerCommand = @"
docker container run --rm -it ``
--mount type=bind,source=$PSScriptRoot,target=/data ``
--mount type=bind,source=$(Join-Path ~ .ssh),target=/.ssh ``
--mount type=bind,source=C:\_cp,target=/_cp ``
--mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock ``
release-generation:latest ``
/data/generate-release.ps1 -Verbose
"@
    Write-Host $dockerCommand
    Invoke-Expression $dockerCommand
}

if ($Get)
{
    $dockerCommand = @"
docker container run --rm -it ``
--mount type=bind,source=$PSScriptRoot,target=/data ``
--mount type=bind,source=$(Join-Path ~ .ssh),target=/.ssh ``
--mount type=bind,source=C:\_cp,target=/_cp ``
--mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock ``
release-generation:latest ``
/data/get-release.ps1 -Verbose
"@
    Write-Host $dockerCommand
    Invoke-Expression $dockerCommand
}

