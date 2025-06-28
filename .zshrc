# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gozilla"

plugins=(
    git
    zsh-autosuggestions
    web-search
    zsh-syntax-highlighting
)


ZSH_AUTOSUGGEST_STRATEGY=(history completion)

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=magenta
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=white',underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green

# Bind accepting autosuggest to Ctrl-S
bindkey '^s' autosuggest-accept


# --- Env vars ---

export PAGER=less

# Increase history file size
export HISTFILESIZE=50000
export HISTSIZE=50000

# Useless
unset rc
unset SSH_ASKPASS

# Export bashrc.d
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

# --- Path exports ---

if ! [[ "$PATH" != *"$HOME/.local/bin:$HOME/bin:"* ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

path_exports=(
	"$HOME/scripts"
	"$HOME/local/scripts"
	# Go
	"/usr/local/go/bin"
	"$HOME/go/bin"
	# Rust
	"~/.cargo/bin"
)

for export in "${path_exports[@]}"; do
	if [[ -d "$export" && ":$PATH:" != *":$dir:"* ]]; then
		PATH="$PATH:$export"
	fi
done
export PATH

# --- Aliases ---

alias eza="eza --long --git --icons"
alias ezal="eza --long --git --icons --tree"

# --- Zsh-stuff ---

source $ZSH/oh-my-zsh.sh

PROMPT='%{$fg_bold[yellow]%}➜  %{$fg[yellow]%}%c %{$fg_bold[cyan]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
