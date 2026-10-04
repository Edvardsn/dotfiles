# Requires the PsBash module: Install-Module -Name PsBash

$env:ZELLIJ_CONFIG_DIR = Join-Path $HOME '.config\zellij'

# Settings
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key Shift+Tab -Function TabCompletePrevious
}

# Aliases

## Config
function reload { . $PROFILE }
function bashrc { nvim "$HOME/.bashrc" }
function nvimc { nvim "$HOME/.config/nvim/init.lua" }

## Operations
function cdup { Set-Location .. }
function cdupp { Set-Location ../.. }
function cduppp { Set-Location ../../.. }
Set-Alias -Name '..' -Value cdup
Set-Alias -Name '...' -Value cdupp
Set-Alias -Name '....' -Value cduppp
Set-Alias -Name lg -Value lazygit
function ff { fd . | fzf }
Remove-Item Alias:ls -ErrorAction SilentlyContinue
function ls { eza -lah --icons --no-git --header --group-directories-first --sort=name @args }

$env:EDITOR = 'nvim'

if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch
}

