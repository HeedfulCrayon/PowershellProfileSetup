
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

# Download organization

function New-Folder {
  param (
    [string]$folderPath,
    [string]$name
  )
  if (Test-Path -PathType Container $folderPath) {
    New-Item -ItemType "directory" -Force -Path $folderPath -Name $name
  }
}

# Create Folders
New-Folder "$env:USERPROFILE\Downloads\" "Installs"
New-Folder "$env:USERPROFILE\Downloads\" "Documents"
New-Folder "$env:USERPROFILE\Downloads\" "Pictures"

# Create Watcher
$FileSystemWatcher = New-Object System.IO.FileSystemWatcher
$FileSystemWatcher.Path  = "$env:USERPROFILE\Downloads"

  Register-ObjectEvent -InputObject $FileSystemWatcher  -EventName Created  -Action {

  $ext = [System.IO.Path]::GetExtension($Event.SourceEventArgs.Name)
  $pathToCopyTo = ""
  switch ($ext) {
    {$_ -in ".pdf",".doc",".docx",".xls",".xlsx",".txt"} { $pathToCopyTo = "$env:USERPROFILE\Downloads\Documents\" }
    {$_ -in ".jpg",".jpeg",".png",".gif"} { $pathToCopyTo = "$env:USERPROFILE\Downloads\Pictures\" }
    {$_ -in ".exe",".msi"} { $pathToCopyTo = "$env:USERPROFILE\Downloads\Installs\" }
  }
  $Object  = "{0} was  {1} at {2} was copied to {3}" -f $Event.SourceEventArgs.FullPath, $Event.SourceEventArgs.ChangeType, $Event.TimeGenerated, $pathToCopyTo

  $WriteHostParams  = @{

  ForegroundColor = 'Green'

  BackgroundColor =  'Black'

  Object =  $Object

  }
  Move-Item $Event.SourceEventArgs.FullPath -Destination $pathToCopyTo -Force
  Write-Host @WriteHostParams

}


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
