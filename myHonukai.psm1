#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    
    $prompt = Get-AdministratorSymbol
    # write user
    $user = [System.Environment]::UserName
    if (Test-NotDefaultUser($user)) {
        $prompt += Write-Prompt -Object " $user" -ForegroundColor $sl.Colors.NameColor
        # write at (devicename)
        $device = Get-ComputerName
        $prompt += Write-Prompt -Object " at" -ForegroundColor $sl.Colors.RegularTextColor
        $prompt += Write-Prompt -Object " $($env:Userdomain)\$device" -ForegroundColor $sl.Colors.DomainAndComputerColor
        # write in for folder
        $prompt += Write-Prompt -Object " in" -ForegroundColor $sl.Colors.RegularTextColor
    }
    # write folder
    $dir = Get-FullPath -dir $pwd
    $prompt += Write-Prompt -Object " $dir " -ForegroundColor $sl.Colors.DirectoryColor
    # write on (git:branchname status)
    $status = Get-VCSStatus
    if ($status) {
        $sl.GitSymbols.BranchSymbol = ''
        $themeInfo = Get-VcsInfo -status ($status)
        $prompt += Write-Prompt -Object 'on git:' -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$($themeInfo.VcInfo) " -ForegroundColor $themeInfo.BackgroundColor
    }
    # write virtualenv
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object 'inside env:' -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$(Get-VirtualEnvName) " -ForegroundColor $themeInfo.VirtualEnvForegroundColor
    }
    # write [time]
    $timeStamp = Get-Date -Format T
    $prompt += Write-Prompt "[$timeStamp]" -ForegroundColor $sl.Colors.RegularTextColor
    
    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }

    $prompt += Set-Newline
    
    # check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.PromptFailedIndicator -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor
    }else {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.PromptIndicator -ForegroundColor $sl.Colors.PromptHighlightColor
    }
     
    $prompt += ' '
    $prompt
}

function Get-TimeSinceLastCommit {
    return (git log --pretty=format:'%cr' -1)
}

function Get-AdministratorSymbol {
    If (Test-Administrator) {
        return Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -ForegroundColor $sl.Colors.AdminIconForegroundColor
    } else {
        return Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.PromptHighlightColor
    }
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.StartSymbol = '#'
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x2713)
$sl.PromptSymbols.PromptFailedIndicator = [char]::ConvertFromUtf32(0x2718)
$sl.Colors.PromptHighlightColor = [ConsoleColor]::Green
$sl.Colors.NameColor = [ConsoleColor]::Green
$sl.Colors.RegularTextColor = [ConsoleColor]::Gray
$sl.Colors.DomainAndComputerColor = [ConsoleColor]::Red
$sl.Colors.DirectoryColor = [ConsoleColor]::Blue
$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvForegroundColor = [ConsoleColor]::Red
