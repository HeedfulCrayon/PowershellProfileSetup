
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
Set-Alias -Name OS -Value Open-Solution

function edit {
    param (
        $file
    )
    code $file
}

function Open-Solution {
  $currentLocation = Get-Location
  $projLocation = "$env:userprofile\Projects\"
  Set-Location $projLocation
  $selectedSolution = rg -g '*.sln' --files | invoke-fzf
  if ($selectedSolution -ne "") {
      $projLocation + $selectedSolution | Invoke-Item
  }
  Set-Location $currentLocation
}


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
