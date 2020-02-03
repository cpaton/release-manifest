[CmdletBinding()]
param()

. ( Join-Path $PSScriptRoot "scripts/ModuleBootstrap.ps1" ) `
    -ModuleRoot $PSScriptRoot `
    -Customise {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [hashtable]
            $Settings
        )

        $Settings.Scripts = @{
            Exec = Join-Path $Settings.Root "scripts/Exec"
        }
        $Settings.TypesRoot = Join-Path $Settings.Root "types"    
    }