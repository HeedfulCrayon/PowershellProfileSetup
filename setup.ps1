Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
cinst git.install -y
cinst cmder -y
Set-Location $env:USERPROFILE\Downloads\
git clone https://github.com/powerline/fonts.git

.\fonts\install.ps1

#Import Cmder Settings
#TODO figure out where chocolatey installs cmder

#Install Modules and import them
Install-PackageProvider NuGet -MinimumVersion '2.8.5.201' -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 'PSFzf'
Install-Module -Name 'ZLocation'
Install-Module -Name 'posh-git'
Install-Module -Name 'oh-my-posh'
Install-Module -Name 'Get-ChildItemColor'
Import-Module 'ZLocation'
Import-Module 'PSFzf'
Import-Module 'posh-git'
Import-Module 'oh-my-posh'
Import-Module 'Get-ChildItemColor'

$poshVersion = (Get-ChildItem "C:\Program Files\WindowsPowerShell\Modules\oh-my-posh\" | Sort-Object -Property LastWriteTime | Select-Object -First 1).Name
copy-item .\myHonukai.psm1 -Destination "C:\Program Files\WindowsPowerShell\Modules\oh-my-posh\$poshVersion\Themes\"
Set-Theme myHonukai
choco install ripgrep