[CmdletBinding()]
param ()

$dockerCommand = @"
docker container run --rm -it ``
--env GIT_AUTHOR_NAME='$(git config --get user.name)' ``
--env GIT_AUTHOR_EMAIL='$(git config --get user.email)' ``
--env GIT_COMMITTER_NAME='$(git config --get user.name)' ``
--env GIT_COMMITTER_EMAIL='$(git config --get user.email)' ``
--mount type=bind,source=$PSScriptRoot,target=/data/module ``
--mount type=bind,source=$(Join-Path ~ .ssh),target=/.ssh ``
--mount type=bind,source=C:\_cp,target=/_cp ``
--mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock ``
release-generation:latest ``
/data/module/create-release.ps1 -AppVersion 0.40.13 -Verbose
"@
    Write-Host $dockerCommand
    Invoke-Expression $dockerCommand

# if ($Generate)
# {
#     $dockerCommand = @"
# docker container run --rm -it ``
# --mount type=bind,source=$PSScriptRoot,target=/data ``
# --mount type=bind,source=$(Join-Path ~ .ssh),target=/.ssh ``
# --mount type=bind,source=C:\_cp,target=/_cp ``
# --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock ``
# release-generation:latest ``
# /data/generate-release.ps1 -Verbose
# "@
#     Write-Host $dockerCommand
#     Invoke-Expression $dockerCommand
# }

# if ($Get)
# {
#     $dockerCommand = @"
# docker container run --rm -it ``
# --mount type=bind,source=$PSScriptRoot,target=/data ``
# --mount type=bind,source=$(Join-Path ~ .ssh),target=/.ssh ``
# --mount type=bind,source=C:\_cp,target=/_cp ``
# --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock ``
# release-generation:latest ``
# /data/get-release.ps1 -Verbose
# "@
#     Write-Host $dockerCommand
#     Invoke-Expression $dockerCommand
# }

