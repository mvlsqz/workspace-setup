# workspace-setup

Repository to store my dotfiles and tooling configurations for a productive development environment.

## What's Included

This repository contains configuration files for:

- **Neovim** - LazyVim-based configuration with extensive LSP support (372+ language servers)
- **Aerospace** - i3-like tiling window manager for macOS with borders integration
- **Fish Shell** - Enhanced shell with plugin manager and multiple integrations
- **Ghostty** - Fast, native terminal emulator with custom themes
- **Tmux** - Terminal multiplexer with vi-mode keybindings

## Repository Structure

```
.
├── config/
│   ├── nvim/                  # Neovim LazyVim configuration
│   │   ├── init.lua          # Entry point
│   │   ├── lua/
│   │   │   ├── config/       # Core configurations (keymaps, options, autocmds)
│   │   │   ├── core/         # Lazy.nvim and LSP setup
│   │   │   ├── mvlsqz/       # Personal customizations
│   │   │   └── plugins/      # Plugin configurations
│   │   ├── lsp/              # 372+ LSP server configurations
│   │   ├── ftdetect/         # Filetype detection
│   │   ├── ftplugin/         # Filetype-specific settings
│   │   └── lazy-lock.json    # Plugin version lock file
│   │
│   ├── aerospace/            # Aerospace window manager
│   │   └── aerospace.toml    # Enhanced config with borders integration
│   │
│   ├── fish/                 # Fish shell configuration
│   │   ├── config.fish       # Main configuration with tmux auto-start
│   │   ├── fish_plugins      # Fisher plugin list
│   │   ├── conf.d/           # Additional configurations
│   │   │   ├── nvm.fish      # Node Version Manager
│   │   │   ├── rvm.fish      # Ruby Version Manager
│   │   │   ├── sdk.fish      # SDKMAN! integration
│   │   │   ├── tmux.fish     # Tmux integration
│   │   │   └── fish-ssh-agent.fish
│   │   ├── functions/        # Custom Fish functions
│   │   └── completions/      # Shell completions
│   │
│   └── ghostty/              # Ghostty terminal
│       ├── config            # Main config with Monaspace font
│       └── themes/           # Custom themes
│           ├── day           # Light theme
│           ├── latte         # Catppuccin Latte
│           ├── mocha         # Catppuccin Mocha
│           └── moon          # Dark theme
│
├── .tmux.conf                # Tmux configuration
├── .gitignore
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
   cp -r config/nvim ~/.config/

   # Aerospace
   cp -r config/aerospace ~/.config/

   # Fish Shell
   cp -r config/fish ~/.config/

   # Ghostty
   cp -r config/ghostty ~/.config/

   # Tmux
   cp .tmux.conf ~/
   ```

### Using Symbolic Links (Recommended)

Symbolic links allow you to keep the configurations in sync with the repository:

```bash
# Neovim
ln -s "$(pwd)/config/nvim" ~/.config/nvim

# Aerospace
ln -s "$(pwd)/config/aerospace" ~/.config/aerospace

# Fish Shell
ln -s "$(pwd)/config/fish" ~/.config/fish

# Ghostty
ln -s "$(pwd)/config/ghostty" ~/.config/ghostty

# Tmux
ln -s "$(pwd)/.tmux.conf" ~/.tmux.conf
```

## Configuration Highlights

### Neovim
- **LazyVim Distribution**: Modern, fast configuration framework
- **372+ LSP Configurations**: Comprehensive language server support for virtually any language
- **Plugin Manager**: Lazy.nvim for efficient plugin loading
- **Custom Plugins**:
  - Blink completion engine
  - Custom colorscheme configuration
  - Neo-tree file explorer
  - Custom status line
  - Tmux navigator integration
- **Organized Structure**: Separated config, core, and plugin directories
- **Filetype Support**: Custom detection for Ansible, Jinja, Terraform, Groovy, JSON

### Aerospace
- **Enhanced Navigation**: Cmd-based hjkl navigation instead of Alt
- **Borders Integration**: Visual window borders with custom colors (active: #e1e3e4, inactive: #494d64)
- **9 Workspaces**: Quick switching with Cmd+1-9
- **Smart Layouts**: Tiles and accordion modes with custom padding (30px)
- **Window Gaps**: 10px gaps on all sides
- **Mouse Integration**: Follows focus to monitors and windows
- **Quick Terminal**: Cmd+Enter opens Ghostty in home directory
- **Auto-start**: Launches at login

### Fish Shell
- **Plugin Manager**: Fisher for managing plugins
- **Integrated Tools**:
  - **NVM**: Node Version Manager integration
  - **RVM**: Ruby Version Manager support
  - **SDKMAN!**: Java/JVM tool management
  - **SSH Agent**: Automatic SSH agent management
  - **Tmux Integration**: Auto-start tmux with session naming
- **Custom Functions**: Including `goto`, `fisher`, and version managers
- **Completions**: Shell completions for nvm, sdk, and fisher
- **Rancher Desktop**: Path integration for container management
- **Custom Prompt**: fish_prompt function for enhanced terminal display

### Ghostty
- **Monaspace Font Family**: 
  - Argon Frozen (Light) for regular text
  - Krypton Var (ExtraBold) for bold
  - Radon (Wide SemiBold Italic) for italics
- **Large Font Size**: 23pt for comfortable reading
- **OpenType Features**: Complete stylistic sets (ss01-ss08), ligatures, and contextual alternates
- **Custom Themes**: Four themes (day, latte, mocha, moon)
- **Hidden Titlebar**: macOS native look with hidden titlebar
- **High Opacity**: 98% background opacity
- **macOS Option as Alt**: Proper key mapping for terminal usage
- **Enhanced Scrolling**: 2x scroll multiplier
- **Custom Cell Dimensions**: 25% increased cell height
- **Minimal Decorations**: No window shadow or decorations

### Tmux
- **Ctrl+a Prefix**: Ergonomic alternative to Ctrl+b
- **Vi Mode**: Full vi-mode keybindings for copy operations
- **Vim-style Navigation**: hjkl for pane selection
- **Alt Key Shortcuts**: No prefix needed for window and pane switching
- **Intuitive Splits**: `|` for horizontal, `-` for vertical splits
- **Mouse Support**: Full mouse integration
- **Top Status Bar**: Status bar positioned at top
- **Window Numbering**: Starts at 1 instead of 0
- **Auto-renumbering**: Windows renumber automatically

## Key Features

### Fish Plugins (via Fisher)
- **jorgebucaran/fisher**: Plugin manager
- **reitzig/sdkman-for-fish**: SDKMAN! integration for Java/JVM tools
- **danhper/fish-ssh-agent**: SSH agent management
- **budimanjojo/tmux.fish**: Tmux session management with auto-start
- **jorgebucaran/nvm.fish**: Node.js version management
- **oh-my-fish/plugin-rvm**: Ruby version management

### Neovim Plugins (LazyVim-based)
- **Blink**: Advanced completion engine
- **Neo-tree**: Modern file explorer
- **Custom Status Line**: Personalized status line configuration
- **Tmux Navigator**: Seamless navigation between tmux panes and vim splits
- **Custom Colorscheme**: Personalized theme configuration

### Special Integrations
- **Borders (macOS)**: Visual borders for Aerospace windows
- **Rancher Desktop**: Container management integration in Fish
- **Lazy.nvim**: Fast and flexible plugin manager for Neovim

## Customization

Feel free to customize these configurations to match your preferences. Each configuration file is well-commented to help you understand and modify settings.

### Personal Customizations
- `config/nvim/lua/mvlsqz/init.lua`: Personal Neovim customizations
- `config/fish/conf.d/00-env.fish`: Environment variables
- `config/ghostty/themes/`: Custom terminal themes

## Requirements

Make sure you have the following tools installed:
- [Neovim](https://neovim.io/) (v0.10.0 or later recommended for LazyVim)
- [Aerospace](https://github.com/nikitabobko/AeroSpace) (macOS only)
- [Fish Shell](https://fishshell.com/)
- [Ghostty](https://ghostty.org/)
- [Tmux](https://github.com/tmux/tmux)

### Optional Dependencies
- **Borders**: For Aerospace window borders (install via Homebrew)
  ```bash
  brew install borders
  ```
- **Fisher**: Fish plugin manager (auto-installs on first Fish start)
- **Font**: [Monaspace](https://monaspace.githubnext.com/) font family for Ghostty
- **Node.js**: For NVM integration
- **Ruby**: For RVM integration
- **Java**: For SDKMAN! integration

## Post-Installation

### First-time Setup

1. **Neovim**: On first launch, LazyVim will automatically install all plugins:
   ```bash
   nvim
   ```
   Wait for all plugins to install, then restart Neovim.

2. **Fish Shell**: Install Fisher and plugins:
   ```bash
   fish
   # Fisher will auto-install from fish_plugins file
   ```

3. **Aerospace**: Install borders for visual enhancements:
   ```bash
   brew install borders
   ```

4. **Tmux**: Source the configuration:
   ```bash
   tmux source-file ~/.tmux.conf
   ```

### Verifying Installation

- **Neovim LSP**: Open any file in Neovim and check `:LspInfo` to see active language servers
- **Fish Plugins**: Run `fisher list` to see installed plugins
- **Aerospace**: Check if borders are active with window focus changes
- **Ghostty Themes**: Verify theme switching between light/dark modes

### Troubleshooting

- **Neovim plugins not loading**: Run `:Lazy sync` in Neovim
- **Fish functions missing**: Run `fisher update` to reinstall plugins
- **Tmux key bindings not working**: Ensure you're using the Ctrl+a prefix
- **Aerospace borders not showing**: Check if borders service is running

## License

MIT License - see [LICENSE](LICENSE) file for details.
