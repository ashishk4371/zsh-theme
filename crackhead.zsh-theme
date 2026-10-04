autoload -Uz vcs_info

precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats ' [%F{82}%r:%b%f]'

get_repo_language_icon() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        if [[ "$PWD" == "$HOME" ]]; then REPO_ICON="%F{123}  %f" else REPO_ICON="%F{242}  %f" fi
        return
    fi

    # Find the top root path of the current Git project
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

# Gather matching files recursively into arrays using NullGlob (N)
    local java_files=( $repo_root/**/*.java(N) $repo_root/**/pom.xml(N) )
    local shell_files=( $repo_root/**/*.sh(N) $repo_root/**/*.zsh(N) $repo_root/**/*.bash(N) )
    local python_files=( $repo_root/**/*.py(N) $repo_root/**/requirements.txt(N) )
    local js_files=( $repo_root/**/*.js(N) $repo_root/**/*.ts(N) $repo_root/**/package.json(N) )

    # Read array lengths using the Zsh '#' parameter count flag
    local java_count=${#java_files}
    local shell_count=${#shell_files}
    local python_count=${#python_files}
    local js_count=${#js_files}

    # Initialize comparison tracking variables
    local max_count=0
    REPO_ICON="%F{123} %f" # Default if all counts are 0
    
    # Determine which language has the strict absolute majority
    if (( java_count > max_count )); then
        max_count=$java_count
        REPO_ICON="%F{123}󰬷 %f"   # Java wins
    fi
    if (( shell_count > max_count )); then
        max_count=$shell_count
        REPO_ICON="%F{123} %f"    # Shell scripts win
    fi
    if (( python_count > max_count )); then
        max_count=$python_count
        REPO_ICON="%F{123} %f"    # Python wins
    fi    
    if (( js_count > max_count )); then
	max_count=$js_count
	REPO_ICON="%F{123}󰌞 %f"     # js files
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd get_repo_language_icon
add-zsh-hook precmd get_repo_language_icon

PROMPT='[%n@%F{#FF4D4D}%m%f]%B$%b '

set_terminal_background() {
  printf '\033]11;#000000\007'
}

#set_terminal_background

