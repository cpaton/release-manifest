$tagPrefix = "release-"
"release-0.40.13" -match "^$tagPrefix(?<version>\d+\.\d+\.?\d*\.?\d*)(-(?<revision>\d+))?$"
"release-0.40.13-1" -match "^$tagPrefix(?<version>\d+\.\d+\.?\d*\.?\d*)(-(?<revision>\d+))?$"
Write-Host "X: $($Matches['revision'])"