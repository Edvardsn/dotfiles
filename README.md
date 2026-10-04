# dotfiles
Main config across all windows development.

## Zellij

The `.config/zellij` folder contains the Zellij config, F1 shortcut help, and
the zjstatus 0.25.0 plugin used by the compact status bar. Copy this folder to
`$HOME/.config/zellij`. The PowerShell profile sets `ZELLIJ_CONFIG_DIR` to that location.

The config currently uses absolute paths under `C:/Users/Pette`; update those
paths in `config.kdl` when setting up another user account.

`Ctrl+Space` enters leader mode; `Esc` returns to typing. Press `F1` for help.
The help text in `shortcuts.ps1` is maintained manually alongside the keybindings.

# Div

Install-Module PsBash

# Illustration

```text
Windows 11
│
├── WezTerm
│   ├── terminal emulator
│   ├── panes / tabs / workspaces
│   └── SSHMUX
│       └── persistent remote terminal sessions
│
├── Git Bash
│   └── interactive Bash shell
│
├── Native Windows CLI tools
│   ├── git
│   ├── lazygit
│   ├── neovim
│   ├── starship
│   ├── eza
│   ├── ripgrep
│   ├── fd
│   ├── fzf
│   ├── zoxide
│   ├── chezmoi
│   ├── delta
│   └── glab
│
├── Docker Desktop
│   └── project-specific environment
│       ├── node
│       ├── python
│       ├── ruby
│       ├── gcc
│       ├── sonar
│       ├── databases
│       └── other project dependencies
│
└── Native GUI apps
    ├── JetBrains
    └── 1Password
    ........
```
