function Resolve-GitInput
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        $Definition    
    )

    $ErrorActionPreference = "Stop"

    if ($Definition.ref -match '[0-9a-f]{40}')
    {
        $Definition.CommitId = $Definition.ref
        return
    }

    $env:GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
    $reference = & $releaseManifestModule.Scripts.Exec "git ls-remote --refs --heads --tags --quiet --exit-code $($Definition.remote) $($Definition.ref)" "List remote refs"
    if ($LASTEXITCODE -ne 0)
    {
        throw "$($Definition.ref) not found in remote $($Definition.remote)"
    }
    if ($reference -notmatch "^(?<commitId>[^\s]+)\s+refs/(heads|tags)/(?<ref>.+)$")
    {
        throw "Unable to parse refernce $reference"
    }
    $refCommitId = $Matches['commitId']
    $Definition.CommitId = $refCommitId

    Write-Verbose "$($Definition.Remote):$($Definition.Ref) -> $($Definition.CommitId)"
}
Export-ModuleMember -Function Resolve-GitInput