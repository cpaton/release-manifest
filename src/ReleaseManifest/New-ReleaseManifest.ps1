function New-ReleaseManifest()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 1)]
        [string]
        $Name,
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

    # $releaseJson = ConvertTo-Json $release
    # Set-Content -Path /data/release.json -Value $releaseJson
}
Export-ModuleMember -Function New-ReleaseManifest