#!/bin/bash

set -e

# Check if repository URL is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 https://github.com/Bala-Vignesh-Reddy/terminal-setup.git" 
    exit 1
fi

REPO_URL=$1

# Detect OS
detect_os() {
    if [ "$(uname -s)" = "Linux" ]; then
        echo "Linux"
    elif [ "$(uname -s)" = "Darwin" ]; then
        echo "macOS"
    else
        echo "Unsupported OS"
        exit 1
    fi
}

OS=$(detect_os)
echo $OS

# Install tools
 if [ "$OS" = "Linux" ]; then
     sudo apt update
     [ ! "$(command -v nvim)" ] && sudo apt install -y neovim
     [ ! "$(command -v tmux)" ] && sudo apt install -y tmux
     [ ! "$(command -v fdfind)" ] && sudo apt install -y fd-find
     [ ! "$(command -v fzf)" ] && sudo apt install -y fzf
     [ ! "$(command -v git)" ] && sudo apt install -y git
 elif [ "$OS" = "macOS" ]; then
     if ! command -v brew &> /dev/null; then
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     fi
     [ ! "$(command -v nvim)" ] && brew install neovim
     [ ! "$(command -v tmux)" ] && brew install tmux
     [ ! "$(command -v fd)" ] && brew install fd
     [ ! "$(command -v fzf)" ] && brew install fzf
     [ ! "$(command -v git)" ] && brew install git
 fi

 # Clone or update dotfiles
 if [ -d "$HOME/dotfiles" ]; then
     cd "$HOME/dotfiles"
     git pull
 else
     git clone "$REPO_URL" "$HOME/dotfiles"
 fi

 # Ensure .config directory exists
 mkdir -p "$HOME/.config"

 # Symlink nvim to ~/.config/nvim
 [ -L "$HOME/.config/nvim" ] && rm "$HOME/.config/nvim"
 [ -e "$HOME/.config/nvim" ] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
 ln -s "$HOME/dotfiles/nvim" "$HOME/.config/nvim"

 # Symlink tmux.conf to ~/tmux.conf
 [ -L "$HOME/tmux.conf" ] && rm "$HOME/tmux.conf"
 [ -e "$HOME/tmux.conf" ] && mv "$HOME/tmux.conf" "$HOME/tmux.conf.bak"
 ln -s "$HOME/dotfiles/tmux/tmux.conf" "$HOME/tmux.conf"

 # Symlink scripts to ~/scripts
 [ -L "$HOME/scripts" ] && rm "$HOME/scripts"
 [ -e "$HOME/scripts" ] && mv "$HOME/scripts" "$HOME/scripts.bak"
 ln -s "$HOME/dotfiles/scripts" "$HOME/scripts"
 find "$HOME/scripts" -type f -exec chmod +x {} \;
echo "Setup complete! Your development environment is ready."
echo "Start Neovim to initialize LazyVim plugins."
