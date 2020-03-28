<#
.SYNOPSIS
Given a Git reference returned from the Git command line e.g.
Parses the result into the commitID and reference

.OUTPUTS
[hashtable] If the reference can be parsed
$null if the reference could not be parsed
#>
function ParseGitRef()
{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        # Git ref to parse 
        # e.g. c96b9a1dfc5be1933a37665162b4bc5a099fef15       refs/tags/release-0.40.13-13
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
}