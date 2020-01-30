[CmdletBinding()]
[OutputType([hashtable])]
param(
    [Parameter(Mandatory, Position = 1)]
    [string]
    $Ref
)

Write-Verbose "Parsing $Ref"
if ($Ref -match "^(?<commitId>[^\s]+)\s+refs/(heads|tags)/(?<ref>.+)$")
{
    @{
        CommitId = $Matches['commitId']
        Ref = $Matches['ref']
    }
}