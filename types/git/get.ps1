[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 1)]
    $Definition,
    [Parameter(Mandatory, Position = 2)]
    [string]
    $Root
)

$ErrorActionPreference = "Stop"

$exec = Join-Path $PSScriptRoot "../../exec.ps1"

$env:GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
$references = & $exec "git ls-remote --refs --heads --tags --quiet $($Definition.remote)" "List remote refs"
$matchingReferenceDetails = $references | Where-Object { $_.StartsWith($Definition.CommitId) } | Select-Object -First 1
$remoteReference = $null
if ($matchingReferenceDetails -match "^(?<commitId>[^\s]+)\s+refs/(heads|tags)/(?<ref>.+)$")
{
    $remoteReference = $Matches['ref']
}

$clonePath = Join-Path $Root $Definition.name
if (Test-Path $clonePath)
{
    Remove-Item -Path $clonePath -Recurse -Force
}

if ($remoteReference)
{
    Write-Verbose "Found ref $remoteReference pointing to required commit $($Definition.CommitId) - cloning just this reference"
    & $exec "git clone --branch $remoteReference --depth=1 --single-branch -- $($Definition.remote) $clonePath" "Clone single branch"
}
else
{
    & $exec "git clone -- $($Definition.remote) $clonePath" "Clone remote"
    Set-Location $clonePath
    try
    {
        & $exec "git checkout $($Definition.CommitId)" "Checkout commit $($Definition.CommitId)"
    }
    finally
    {
        Pop-Location
    }
}