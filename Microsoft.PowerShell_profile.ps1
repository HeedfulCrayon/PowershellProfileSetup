
Remove-PSReadlineKeyHandler 'Ctrl+r'
Import-Module Get-ChildItemColor
Import-Module 'posh-git'
Import-Module 'oh-my-posh'
Set-Theme myHonukai
Import-Module ZLocation
Import-Module PSFzf
Set-alias -Name f -Value Invoke-fzf
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
Set-Alias gci Get-ChildItemColor -Option AllScope -force

function edit {
    param (
        $file
    )
    code $file
}


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
