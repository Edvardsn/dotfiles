$ErrorActionPreference = 'Stop'

$winget = Get-Command winget.exe -ErrorAction SilentlyContinue
if (-not $winget) {
    throw 'WinGet is missing or not on PATH.'
}

function Test-PackageInstalled {
    param([string]$Package)

    & $winget.Source list --exact --id $Package --source winget `
        --accept-source-agreements --disable-interactivity *> $null
    return $LASTEXITCODE -eq 0
}

$packages = @(
    'Git.Git'
    'twpayne.chezmoi'
    'JesseDuffield.lazygit'
    'Neovim.Neovim'
    'Starship.Starship'
    'Fastfetch-cli.Fastfetch'
    'eza-community.eza'
    'BurntSushi.ripgrep.MSVC'
    'sharkdp.fd'
    'junegunn.fzf'
    'ajeetdsouza.zoxide'
    'dandavison.delta'
    'GLab.GLab'
    'JetBrains.Toolbox'
    'AgileBits.1Password'
    'Docker.DockerDesktop'
)

foreach ($package in $packages) {
    if (Test-PackageInstalled $package) {
        Write-Host "Already installed: $package"
        continue
    }

    Write-Host "`nInstalling $package"
    $arguments = @(
        'install', '--exact', '--id', $package, '--source', 'winget',
        '--accept-source-agreements', '--accept-package-agreements'
    )
    if ($package -eq 'Docker.DockerDesktop') {
        $arguments += @(
            '--scope', 'machine',
            '--override', 'install --quiet --accept-license --backend=hyper-v'
        )
    }

    & $winget.Source @arguments
    if ($LASTEXITCODE -ne 0) {
        # Some installers exit non-zero even though they installed cleanly,
        # so confirm before giving up.
        if (Test-PackageInstalled $package) {
            Write-Host "Installer reported an error but $package is installed. Continuing."
            continue
        }
        throw "Installation failed: $package. Resolve the error, then rerun."
    }
}

$modules = @(
    'PsBash'
)

foreach ($module in $modules) {
    if (Get-Module -ListAvailable -Name $module) {
        Write-Host "Already installed: $module"
        continue
    }

    Write-Host "`nInstalling $module"
    Install-Module -Name $module -Scope CurrentUser -Force -AcceptLicense
}

$links = [ordered]@{
    'Microsoft.PowerShell_profile.ps1' = $PROFILE
    '.bashrc'                          = Join-Path $HOME '.bashrc'
}

foreach ($name in $links.Keys) {
    $source = Join-Path $PSScriptRoot $name
    $target = $links[$name]

    $item = Get-Item $target -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -eq 'SymbolicLink' -and $item.Target -eq $source) {
        Write-Host "Already linked: $name"
        continue
    }

    $parent = Split-Path $target -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    if ($item) {
        # Keep whatever was there before replacing it with the repo copy.
        $backup = "$target.bak"
        Write-Host "Backing up existing $name to $backup"
        Move-Item -Path $target -Destination $backup -Force
    }

    Write-Host "Linking $name -> $target"
    New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null
}

Write-Host 'Done. Reboot if requested; otherwise close and reopen your terminal.'
