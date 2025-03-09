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

# Nice blue theme
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=magenta
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=white',underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green

# Bind accepting autosuggest to Ctrl-S
bindkey '^s' autosuggest-accept

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Dark theme
export GTK_THEME=Adwaita:dark

# Go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/whoamii/go/bin

# Rust
export PATH=$PATH:/home/whoamii/.cargo/bin
export PATH

# Increase history file size
export HISTFILESIZE=50000
export HISTSIZE=50000

# Aliases 
alias eza="eza --long --git --icons"
alias ezal="eza --long --git --icons --tree"
alias fz='cd $(find ./ -type d | fzf)'
alias kubectl="minikube kubectl --"
alias usage="du --max-depth=1 2>/dev/null"
alias sc="nvim $HOME/scratchpad.md"


if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
unset SSH_ASKPASS

source $ZSH/oh-my-zsh.sh
PROMPT='%{$fg_bold[yellow]%}➜  %{$fg[yellow]%}%c %{$fg_bold[cyan]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'


eval $(thefuck --alias)
