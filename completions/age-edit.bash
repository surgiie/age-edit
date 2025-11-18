#!/usr/bin/env bash
# Bash completion for age-edit

_age_edit_completion() {
    local cur prev opts commands
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Main commands
    commands="new ls edit rm get help version"

    # If we're on the first argument, suggest commands
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        return 0
    fi

    # Get the command
    local command="${COMP_WORDS[1]}"

    # Common options for all commands
    local common_opts="-h --help"

    # Command-specific options
    case "${command}" in
        new)
            opts="-k --key -n --namespace -e --ext ${common_opts}"
            case "${prev}" in
                -k|--key)
                    # Suggest files for key option
                    COMPREPLY=( $(compgen -f -- ${cur}) )
                    return 0
                    ;;
                -n|--namespace|-e|--ext)
                    # No completion for these, user provides value
                    return 0
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                    return 0
                    ;;
            esac
            ;;
        edit|get|rm)
            opts="-k --key -n --namespace ${common_opts}"
            if [ "${command}" = "rm" ]; then
                opts="${opts} -f --force"
            fi
            if [ "${command}" = "edit" ]; then
                opts="${opts} -e --ext"
            fi
            case "${prev}" in
                -k|--key)
                    COMPREPLY=( $(compgen -f -- ${cur}) )
                    return 0
                    ;;
                -n|--namespace|-e|--ext)
                    return 0
                    ;;
                *)
                    # Try to suggest secret names from default namespace
                    local secrets_dir="${HOME}/.age-edit/contexts/${AGE_EDIT_CONTEXT:-default}/items/default"
                    if [ -d "${secrets_dir}" ]; then
                        local secrets=$(ls -1 "${secrets_dir}" 2>/dev/null | sed 's/\.age$//')
                        COMPREPLY=( $(compgen -W "${secrets} ${opts}" -- ${cur}) )
                    else
                        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                    fi
                    return 0
                    ;;
            esac
            ;;
        ls)
            opts="-n --namespace ${common_opts}"
            case "${prev}" in
                -n|--namespace)
                    return 0
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
                    return 0
                    ;;
            esac
            ;;
        help|version)
            # No options for these commands
            return 0
            ;;
    esac
}

complete -F _age_edit_completion age-edit
