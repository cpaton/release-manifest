[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]
    $ModuleRoot,
    [Parameter()]
    [scriptblock]
    $Customise = $({})
)

# Lookup basic information about the Module
$ModuleName = Split-Path -Path $ModuleRoot -Leaf
$ModuleManifestPath = Join-Path $ModuleRoot "$($ModuleName).psd1"
$ModuleManifest = Invoke-Expression ( Get-Content -Path $ModuleManifestPath -Raw )
$safeModuleName = $ModuleName.Replace('.', '')
$moduleVariableName = "$($safeModuleName)Module"

# Module variable
$moduleVariable = New-Variable -Name $moduleVariableName -PassThru -Value @{ 
    Root = $ModuleRoot
    Version = $ModuleManifest.ModuleVersion
    ManifestPath = $ModuleManifestPath
    Manifest = $ModuleManifest
}
Export-ModuleMember -Variable $moduleVariable.Name

$initScriptBlocks = @()

# Load all ps1 files in the root directory
$ps1Files = Get-ChildItem -Path $ModuleRoot -Filter *.ps1
foreach ($ps1File in $ps1Files)
{
    . $ps1File.FullName
}

. $Customise -Settings $moduleVariable.Value

foreach ($initBlock in $initScriptBlocks)
{
    . $initBlock
}