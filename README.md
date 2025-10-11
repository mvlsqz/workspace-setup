# workspace-setup

Repository to store my dotfiles and tooling configurations for a productive development environment.

## What's Included

This repository contains configuration files for:

- **Neovim** - Modern text editor with Lua configuration
- **Aerospace** - i3-like tiling window manager for macOS
- **Fish Shell** - Smart and user-friendly command line shell
- **Ghostty** - Fast, native, feature-rich terminal emulator
- **Tmux** - Terminal multiplexer for managing multiple terminal sessions

## Repository Structure

```
.
├── .config/
│   ├── nvim/           # Neovim configuration
│   │   └── init.lua
│   ├── aerospace/      # Aerospace window manager configuration
│   │   └── aerospace.toml
│   ├── fish/           # Fish shell configuration
│   │   └── config.fish
│   └── ghostty/        # Ghostty terminal configuration
│       └── config
├── .tmux.conf          # Tmux configuration
├── LICENSE
└── README.md
```

## Installation

You can manually copy individual configuration files or use symbolic links to set up your environment.

### Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mvlsqz/workspace-setup.git
   cd workspace-setup
   ```

2. **Copy configurations to their respective locations:**
   ```bash
   # Neovim
   cp -r .config/nvim ~/.config/

   # Aerospace
   cp -r .config/aerospace ~/.config/

   # Fish Shell
   cp -r .config/fish ~/.config/

   # Ghostty
   cp -r .config/ghostty ~/.config/

   # Tmux
   cp .tmux.conf ~/
   ```

### Using Symbolic Links (Recommended)

Symbolic links allow you to keep the configurations in sync with the repository:

```bash
# Neovim
ln -s "$(pwd)/.config/nvim" ~/.config/nvim

# Aerospace
ln -s "$(pwd)/.config/aerospace" ~/.config/aerospace

# Fish Shell
ln -s "$(pwd)/.config/fish" ~/.config/fish

# Ghostty
ln -s "$(pwd)/.config/ghostty" ~/.config/ghostty

# Tmux
ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf
```

## Configuration Highlights

### Neovim
- Basic settings with line numbers and smart indentation
- Space as leader key
- No swap files, using undo files instead
- True color support

### Aerospace
- Vim-style navigation (hjkl)
- 9 workspaces with quick switching
- Customizable gaps between windows
- Resize mode for window management

### Fish Shell
- Aliases for common commands
- Git shortcuts
- Neovim set as default editor
- Clean prompt without greeting

### Ghostty
- JetBrains Mono font
- Catppuccin theme (dark and light variants)
- Shell integration enabled
- Vim-style keybindings

### Tmux
- Ctrl+a as prefix (instead of Ctrl+b)
- Vim-style pane navigation
- Mouse support enabled
- Vi mode for copy operations
- Intuitive split commands (| and -)

## Customization

Feel free to customize these configurations to match your preferences. Each configuration file is well-commented to help you understand and modify settings.

## Requirements

Make sure you have the following tools installed:
- [Neovim](https://neovim.io/) (v0.9.0 or later recommended)
- [Aerospace](https://github.com/nikitabobko/AeroSpace) (macOS only)
- [Fish Shell](https://fishshell.com/)
- [Ghostty](https://ghostty.org/)
- [Tmux](https://github.com/tmux/tmux)

## License

MIT License - see [LICENSE](LICENSE) file for details.
