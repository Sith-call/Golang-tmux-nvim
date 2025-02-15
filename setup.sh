#!/bin/bash

LOG_FILE="setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1  # Save all output to a log file

echo "🚀 Starting Golang development environment setup..."

# Error handling function
error_exit() {
    echo "❌ ERROR: $1"
    exit 1
}

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error_exit "Failed to install Homebrew"
else
    echo "✅ Homebrew already installed."
fi

# Installing required packages
echo "📦 Installing required packages..."
brew install tmux neovim fzf ripgrep git wget go || error_exit "Failed to install packages"

# Setting up tmux plugin manager (TPM)
echo "🛠 Setting up tmux..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || error_exit "Failed to clone TPM"
fi

# Creating tmux configuration file
cat << EOF > ~/.tmux.conf
set -g mouse on
set -g history-limit 10000
set-option -g status-style fg=green

unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

bind -r h select-pane -L
bind -r j select-pane -D
bind -r k select-pane -U
bind -r l select-pane -R

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'

run '~/.tmux/plugins/tpm/tpm'
EOF

echo "🔄 Applying tmux configuration..."
tmux source ~/.tmux.conf || echo "⚠️ Warning: tmux not running, configuration will be applied on next start."

# Installing vim-plug for Neovim
echo "🔌 Installing vim-plug for Neovim..."
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || error_exit "Failed to install vim-plug"
fi

# Creating Neovim configuration file
mkdir -p ~/.config/nvim
cat << EOF > ~/.config/nvim/init.lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true

vim.cmd [[
call plug#begin('~/.local/share/nvim/plugged')

Plug 'nvim-tree/nvim-tree.lua'
Plug 'hoob3rt/lualine.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'jiangmiao/auto-pairs'

call plug#end()
]]

local lspconfig = require'lspconfig'
lspconfig.gopls.setup{}

local cmp = require'cmp'
cmp.setup({
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    }
})

vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
EOF

# Installing Neovim plugins
echo "📥 Installing Neovim plugins..."
nvim +PlugInstall +qall || error_exit "Failed to install Neovim plugins"

# Installing Golang development tools
echo "🛠 Installing Golang development tools..."
go install golang.org/x/tools/gopls@latest \
    github.com/cweill/gotests/gotests@latest \
    github.com/fatih/gomodifytags@latest \
    github.com/josharian/impl@latest \
    github.com/haya14busa/goplay/cmd/goplay@latest \
    github.com/go-delve/delve/cmd/dlv@latest || error_exit "Failed to install Golang tools"

# Configuring environment variables
if ! grep -q 'export PATH=$HOME/go/bin:$PATH' ~/.zshrc; then
    echo 'export PATH=$HOME/go/bin:$PATH' >> ~/.zshrc
    source ~/.zshrc
fi

# Linking vim to nvim
if ! grep -q 'alias vim="nvim"' ~/.zshrc; then
    echo 'alias vim="nvim"' >> ~/.zshrc
    source ~/.zshrc
fi

echo "✅ Setup complete! Start coding with 'nvim' or 'tmux'. 🚀"

