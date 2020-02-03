[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]
    $Name,
    [Parameter()]
    [string]
    $ComponentRef = $('master')
)

$ErrorActionPreference = "Stop"

New-ReleaseManifest $Name {
    [ordered]@{
        AMI = @(
            & $releaseManifestModule.Types.git.create notebook file:///_cp/Git/notebook master
            & $releaseManifestModule.Types.git.create powershell file:///_cp/Git/PowerShell 2a37b01860cabf5834b87e615887231f31ef5eea
            & $releaseManifestModule.Types.maven.create component com.company component 0.40.13
            & $releaseManifestModule.Types."golden-image".create AmazonLinux2
        )
        Deployment = @(
            & $releaseManifestModule.Types.git.create notebook file:///_cp/Git/notebook master
            & $releaseManifestModule.Types.git.create aws-cdk file:///_cp/Git/aws-cdk v1.5.0
        )
    }
}