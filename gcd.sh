# This script is intended to be sourced into your ~/.zshrc or ~/.bashrc.

# Search for worktrees and change directories.
gcd () {
    __gcd_initialize
    __gcd_dir=$(__gcd_worktrees | __gcd_fzf "$@")
    __gcd_finalize
    if test -n "${__gcd_dir}"
    then
        cd "${__gcd_dir}" || return 0
    fi
}

# Initialize the zsh shell environment.
__gcd_initialize () {
    __gcd_restore_zsh_wordsplit=
    if test -n "${ZSH_VERSION}" && test -z "$(setopt | grep shwordsplit)"
    then
        __gcd_restore_zsh_wordsplit=true
        set -o shwordsplit
    fi
}


# Restore the zsh shell environment.
__gcd_finalize () {
    if test -n "${__gcd_restore_zsh_wordsplit}"
    then
        set +o shwordsplit
    fi
}

# Custom fzf used by gcd / gcdi
__gcd_fzf () {
    fzf \
        --ansi \
        --border=none \
        --cycle \
        --filepath-word \
        --info=inline-right \
        --keep-right \
        --preview='eza --all --color=always --git-ignore --group-directories-first --icons {}' \
        --preview-window=down,33%,border-none \
        --query="$*" \
        --scheme=path \
        --tiebreak=end,chunk,length
}

# Find worktrees and print their paths to stdout.
__gcd_worktrees () {
    gcd_paths=$(git config --get-all gcd.paths | envsubst)
    if test -z "${gcd_paths}"
    then
        gcd_paths="${HOME}"
    fi
    OIFS="${IFS}"
    IFS='
'
    set --
    for gcd_path in ${gcd_paths}
    do
        set -- "$@" "${gcd_path}"
    done
    IFS="${OIFS}"

    gcd_depth=$(git config gcd.depth || echo 2)
    # Add + 1 to account for .git.
    gcd_depth=$((gcd_depth + 1))
    fdfind_cmd=
    fdfind_args="--color=never --case-sensitive --hidden --no-ignore --max-depth=${gcd_depth}"
    if type fd >/dev/null 2>&1
    then
        fdfind_cmd=fd
    elif type fdfind >/dev/null 2>&1
    then
        fdfind_cmd=fdfind
    fi
    if test -n  "${fdfind_cmd}"
    then
        # shellcheck disable=SC2086
        "${fdfind_cmd}" ${fdfind_args} '^\.git$' "$@" | xargs -P 4 -n 1 dirname 2>/dev/null
    else
        find -L "$@" -maxdepth ${gcd_depth} -name .git -printf '%h\n' 2>/dev/null
    fi
}
