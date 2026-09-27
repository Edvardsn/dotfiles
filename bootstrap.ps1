$ErrorActionPreference = 'Stop'

$winget = Get-Command winget.exe -ErrorAction SilentlyContinue
if (-not $winget) {
    throw 'WinGet is missing or not on PATH.'
}

$packages = @(
    'Git.Git'
    'twpayne.chezmoi'
    'wez.wezterm'
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
    & $winget.Source list --exact --id $package --source winget `
        --accept-source-agreements --disable-interactivity *> $null
    if ($LASTEXITCODE -eq 0) {
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
        throw "Installation failed: $package. Resolve the error, then rerun."
    }
}

Write-Host 'Done. Reboot if requested; otherwise close and reopen your terminal.'
