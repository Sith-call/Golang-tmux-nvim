# Golang + Neovim + tmux Development Environment Setup

## Overview
This script automates the installation and configuration of a Golang development environment using **Neovim** and **tmux**. It installs all required dependencies, configures Neovim with LSP and autocompletion, and sets up tmux with useful plugins.

## Features
- ✅ Installs **Homebrew**, **tmux**, **Neovim**, **fzf**, **ripgrep**, **git**, **wget**, and **Golang**
- ✅ Configures **tmux** with plugins and keybindings
- ✅ Sets up **Neovim** with **LSP**, **autocompletion**, and essential plugins
- ✅ Installs **Golang development tools** (`gopls`, `gotests`, `gomodifytags`, etc.)
- ✅ Automatically sets **vim → nvim** alias
- ✅ **Safe Guard Logic**: Logs errors and prevents duplicate configurations
- ✅ Stores installation logs in `setup.log`

## Requirements
- **MacOS** (tested on macOS Monterey & Ventura)
- **Homebrew** (if not installed, the script will install it automatically)
- **Internet connection** (to download dependencies)

## Installation & Usage
To install and configure everything in one step, run the following command:

```sh
curl -sSL https://raw.githubusercontent.com/Sith-call/Golang-tmux-nvim/main/setup.sh | bash
```

Or, if you have downloaded `setup.sh`, give it execution permission and run it:

```sh
chmod +x setup.sh
./setup.sh | tee setup.log
```

## What This Script Does
### **1. Installs Required Packages**
```sh
brew install tmux neovim fzf ripgrep git wget go
```

### **2. Configures tmux**
- Installs **tmux Plugin Manager (TPM)**
- Creates `~/.tmux.conf` with optimized settings and keybindings

### **3. Installs Neovim Plugins & Configures LSP**
- Installs `vim-plug`
- Configures **LSP (`gopls`)**, **autocompletion (`nvim-cmp`)**, and **Telescope for fuzzy search**

### **4. Installs Golang Development Tools**
```sh
go install golang.org/x/tools/gopls@latest
```

Additional Go tools installed:
- `gotests` (generate Go test functions)
- `gomodifytags` (modify struct tags)
- `impl` (generate method implementations)
- `goplay` (run Go snippets)
- `delve` (debugging tool)

### **5. Configures Shell & Environment**
- Adds `vim → nvim` alias in `~/.zshrc`
- Ensures `~/go/bin` is in `PATH`

## Logs & Debugging
If something goes wrong, check the installation log:
```sh
cat setup.log
```

## Uninstallation
To remove everything installed by this script, run:
```sh
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim
rm -rf ~/.tmux ~/.tmux.conf
rm -rf ~/.zshrc
brew uninstall tmux neovim fzf ripgrep git wget go
```

## Troubleshooting
### **1. tmux Keybindings Not Working**
- Try running `tmux source ~/.tmux.conf`
- Restart tmux: `tmux kill-server && tmux`

### **2. Neovim Plugins Not Installed**
- Run `nvim +PlugInstall +qall`

### **3. Golang LSP Not Working**
- Run `go install golang.org/x/tools/gopls@latest`
- Ensure `~/.zshrc` contains:
  ```sh
  export PATH=$HOME/go/bin:$PATH
  ```
- Restart shell: `source ~/.zshrc`

## Contribution & Support
If you find issues or have suggestions, please open an issue on GitHub!

**Happy Coding! 🚀**
