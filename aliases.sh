# Source this file from Bash to load aliases for the custom commands.

__renecli_require_clipath() {
    if [ -z "$CLIPATH" ]; then
        printf '%s\n' 'CLIPATH is not set. Add export CLIPATH="$HOME/repos/renedo/renecli" to your Bash profile.' >&2
        return 1
    fi
}

__renecli_awsprof() {
    local export_file exports status

    __renecli_require_clipath || return

    export_file="$(mktemp)" || return

    nu -c "use \"${CLIPATH}/commands.nu\" *; aws-profile --bash-export" \
        | while IFS= read -r line; do
            case "$line" in
                __RENECLI_EXPORT__*)
                    printf '%s\n' "${line#__RENECLI_EXPORT__ }" > "$export_file"
                    ;;
                *)
                    printf '%s\n' "$line"
                    ;;
            esac
        done

    status=${PIPESTATUS[0]}
    exports="$(< "$export_file")"
    rm -f "$export_file"

    if [ "$status" -ne 0 ]; then
        return "$status"
    fi

    if [ -n "$exports" ]; then
        eval "$exports"
    fi
}

alias awsprof='__renecli_awsprof'
alias kns='__renecli_require_clipath && nu -c "use \"${CLIPATH}/commands.nu\" *; kube-namespace"'
alias kcon='__renecli_require_clipath && nu -c "use \"${CLIPATH}/commands.nu\" *; kube-context"'
alias king='__renecli_require_clipath && nu -c "use \"${CLIPATH}/commands.nu\" *; eks-ingress"'
