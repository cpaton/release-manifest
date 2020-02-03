$initScriptBlocks += {
    $typeFolders = Get-ChildItem -Path $releaseManifestModule.TypesRoot | Where-Object { $_.PsIsContainer }
    $releaseManifestModule.Types = @{}

    foreach ($typeFolder in $typeFolders)
    {
        $typeName = Split-Path $typeFolder.FullName -Leaf
        $typeSettings = @{
            Create = Join-Path $typeFolder.FullName "create.ps1"
            Get = Join-Path $typeFolder.FullName "get.ps1"
            Resolve = Join-Path $typeFolder.FullName "resolve.ps1"
        }
        $releaseManifestModule.Types[$typeName] = $typeSettings
    }
}