#!/bin/bash

echo "🚀 Setting up Vim Environment..."

# 1. Define Paths
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIM_DIR="$HOME/.vim"
VIMRC="$HOME/.vimrc"

# 2. Backup existing config
if [ -f "$VIMRC" ]; then
    echo "📦 Backing up existing .vimrc to .vimrc.backup..."
    mv "$VIMRC" "$VIMRC.backup"
fi

if [ -d "$VIM_DIR" ]; then
    echo "📦 Backing up existing .vim folder to .vim.backup..."
    mv "$VIM_DIR" "$VIM_DIR.backup"
fi

echo "Install dependecies"

apt-get update -y && apt-get install -y git curl python3-pip universal-ctags ack-grep fzf ripgrep
apt-get install -y python3-pynvim python3-flake8 pylint python3-isort python3-jedi

# 3. Create Directories & Symlinks
echo "🔗 Linking configuration files..."
mkdir -p "$VIM_DIR"
ln -sf "$REPO_DIR/vimrc" "$VIMRC"
ln -sf "$REPO_DIR/custom.vim" "$VIM_DIR/custom.vim"

# Link UltiSnips folder
ln -sf "$REPO_DIR/UltiSnips" "$VIM_DIR/UltiSnips"

# 4. Download Vim-Plug
echo "🔌 Downloading Vim-Plug..."
curl -fLo "$VIM_DIR/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 5. Install Plugins
echo "📦 Installing Plugins (this may take a moment)..."
vim -es -u "$VIMRC" -i NONE -c "PlugInstall" -c "qa"

echo 'export TERM=xterm-256color' >> ~/.bashrc

echo "✅ Setup Complete! Restart your terminal and type 'vim'."