[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

New-Item -Path /root/.ssh -ItemType Directory | Out-Null
cp -R /.ssh /root
chmod 600 -R /root/.ssh
# ls -la /root/.ssh

$git = Join-Path $PSScriptRoot "types/git/create.ps1"
$maven = Join-Path $PSScriptRoot "types/maven/create.ps1"
$goldenImage = Join-Path $PSScriptRoot "types/golden-image/create.ps1"

$amiInputs = @(
    & $git notebook file:///_cp/Git/notebook master
    & $git powershell file:///_cp/Git/PowerShell 2a37b01860cabf5834b87e615887231f31ef5eea
    & $maven component com.company component 0.40.13
    & $goldenImage AmazonLinux2
)
$deploymentInputs = @(
    & $git notebook file:///_cp/Git/notebook master
    & $git aws-cdk file:///_cp/Git/aws-cdk v1.5.0
)

foreach ($inputList in @($amiInputs, $deploymentInputs))
{
    foreach ($input in $inputList)
    {
        $typeFolder = Join-Path $PSScriptRoot "types\$($input.Type)"
        $resovle = Join-Path $typeFolder "resolve.ps1"

        & $resovle $input
    }
}

$release = [ordered]@{
    Key = [Guid]::NewGuid().ToString()
    Name = "0.40.13"
    AMI = $amiInputs
    Deployment = $deploymentInputs
}

$releaseJson = ConvertTo-Json $release
Set-Content -Path /data/release.json -Value $releaseJson


