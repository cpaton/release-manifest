$initScriptBlocks += {
    $typeFolders = Get-ChildItem -Path $releaseManifestModule.TypesRoot | Where-Object { $_.PsIsContainer }

    foreach ($typeFolder in $typeFolders)
    {
        . ( Join-Path $typeFolder.FullName "new.ps1" )
        . ( Join-Path $typeFolder.FullName "get.ps1" )
        . ( Join-Path $typeFolder.FullName "resolve.ps1" )
        . ( Join-Path $typeFolder.FullName "compare.ps1" )
    }
}