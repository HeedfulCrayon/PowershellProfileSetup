function prompt {
    write-host "$($env:username)@" -foregroundcolor "green" -nonewline
    write-host "$($env:Userdomain)\$($env:computername)" -foregroundcolor "red" -nonewline
    write-host " : " -foregroundcolor "gray" -nonewline
    write-host $pwd -foregroundcolor "blue"
    '> '
}

Remove-PSReadlineKeyHandler 'Ctrl+r'
Import-Module ZLocation
Import-Module PSFzf
Import-Module Get-ChildItemColor
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
