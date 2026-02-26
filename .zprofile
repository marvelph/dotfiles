eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

export PATH=$PATH:~/Library/Android/sdk/platform-tools
export PATH=$PATH:~/Developer/go/bin
export PATH=$PATH:~/.local/bin
