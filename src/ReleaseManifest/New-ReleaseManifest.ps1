<#
.SYNOPSIS
Creates a new manifest which uniquely describes the inputs to a release

.DESCRIPTION
The inputs that form the release are resolved and fixed during the manifeest generation
e.g. a Git branch reference is resolved into the assoicated Git commit
#>
function New-ReleaseManifest()
{
    [CmdletBinding()]
    param(
        # Name for the release.  Convention is to use the main binary version with an optional patch informtion
        # Recommend not using spaces within the name
        [Parameter(Mandatory, Position = 1)]
        [string]
        $Name,
        # Scriptblock which when invoked will return an ordered dictionary of components in the release and their inputs
        # During manifest creation the inputs are resolved into their specific identities based on the current state
        [Parameter(Mandatory, Position = 2)]
        [ScriptBlock]
        $InputGenerator
    )

    $release = [ordered]@{
        Key = [Guid]::NewGuid().ToString()
        Name = $Name
        Inputs = [ordered]@{}
    }

    $Inputs = & $InputGenerator

    foreach ($inputListName in $Inputs.Keys)
    {
        foreach ($input in $Inputs[$inputListName])
        {
            $resovle = "Resolve-$($input.Type)Input"
            & $resovle $input
        }

        $release.Inputs.$inputListName = $Inputs[$inputListName]
    }

    $release
}
Export-ModuleMember -Function New-ReleaseManifest