# Filename: ~/github/dotfiles-latest/zshrc/zshrc-file.sh

# #############################################################################
# Do not delete the `UNIQUE_ID` line below, I use it to backup original files
# so they're not lost when my symlinks are applied
# UNIQUE_ID=do_not_delete_this_line
# #############################################################################

# The AUTO-PULL SECTION has been removed
# now changes have to be explicitly pulled with the alias 'pulldeez' that pulls
# the changes and then sources the zshrc file

source ~/github/dotfiles-latest/zshrc/zshrc-common.sh

# Detect OS
case "$(uname -s)" in
Darwin)
  OS='Mac'
  ;;
Linux)
  OS='Linux'
  ;;
*)
  OS='Other'
  ;;
esac

# macOS-specific configurations
if [ "$OS" = 'Mac' ]; then
  source ~/github/dotfiles-latest/zshrc/zshrc-macos.sh
# Linux (Debian)-specific configurations
elif [ "$OS" = 'Linux' ]; then
  source ~/github/dotfiles-latest/zshrc/zshrc-linux.sh
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/home/bulutcan/.npm-global/bin:$PATH"

# fzf
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border
  --inline-info
"

# zoxide
export _ZO_FZF_OPTS="
  --height=40%
  --layout=reverse
  --border
"

eval "$(zoxide init zsh --cmd cd)"

# Dotfiles Automation
alias dot-save='/home/bulutcan/dotfiles/save.sh'

# Ensure SSH Agent is active
eval $(ssh-agent -s) > /dev/null
ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1
