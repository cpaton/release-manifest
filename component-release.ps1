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
            New-GitInput notebook file:///_cp/Git/notebook master
            New-GitInput notebook file:///_cp/Git/notebook master
            New-GitInput powershell file:///_cp/Git/PowerShell 2a37b01860cabf5834b87e615887231f31ef5eea
            New-MavenInput component com.company component 0.40.13
            New-GoldenImageInput AmazonLinux2
            New-PowerShellModuleInput Creds PSCredentialStore
        )
        Deployment = @(
            New-GitInput notebook file:///_cp/Git/notebook master
            New-GitInput aws-cdk file:///_cp/Git/aws-cdk v1.5.0
        )
    }
}