# Arch Bootstrap

Fresh Arch install icin hedef akisi:

```bash
sudo pacman -Syu --needed git curl
mkdir -p ~/github
git clone https://github.com/bulutcan99/dotfiles-latest.git ~/github/dotfiles-latest
cd ~/github/dotfiles-latest
./install.sh
```

SSH hazir olduktan sonra remote'u SSH'a cevirmek istersen:

```bash
git remote set-url origin git@github.com:bulutcan99/dotfiles-latest.git
```

Script sunlari yapar:

- Arch paketlerini kurar: zsh, tmux, neovim, lazygit, ripgrep, fd, fzf, zoxide, starship, yazi, btop, fastfetch, kitty, ghostty, Rust tooling ve temel build araclari.
- Repo yolunu `~/github/dotfiles-latest` olarak garanti eder.
- Dotfile symlinklerini uygular ve mevcut dosyalari yedekler.
- `~/.config/nvim` ve `~/.config/lazyvim` yollarini bu repo icindeki tek Nvim configine baglar.
- Rust stable toolchain, `rustfmt`, `clippy` ve LazyVim plugin sync adimlarini calistirir.
- Login shell'i zsh yapar.

Opsiyonlar:

```bash
./install.sh --skip-packages
./install.sh --skip-nvim-sync
./install.sh --no-chsh
```
