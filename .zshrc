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
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue,underline
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=cyan',underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# Bind accepting autosuggest to Ctrl-S
bindkey '^s' autosuggest-accept

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

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
alias tmuxwin="tmux new-window -c '#{pane_current_path}'"
alias qpwgraph="QT_STYLE_OVERRIDE=adwaita-dark qpwgraph"
alias eza="eza --long --git --icons"
alias ezal="eza --long --git --icons --tree"
alias fz='cd $(find ./ -type d | fzf)'
alias kubectl="minikube kubectl --"
alias usage="du --max-depth=1 2>/dev/null"
alias sc="nvim $HOME/scratchpad.md"
alias pandocview='f() { pandoc "$1" -o /tmp/markdown.html -H <(echo "\
<style>body { max-width: 600px; margin: 0 auto; padding: 20px; font-family: Arial, sans-serif; }</style>") && firefox /tmp/markdown.html; }; f'

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
PROMPT='%{$fg_bold[cyan]%}➜ %{$fg_bold[green]%} %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

