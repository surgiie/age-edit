declare -g version="0.1.0"
export AGE_EDIT_CLI_VERSION="$version"
export AGE_EDIT_CLI_PATH="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v age >/dev/null 2>&1; then
    error "age is required but not installed. Please install age and try again. See: https://github.com/FiloSottile/age" 1
fi

if [[ -v command_line_args ]]; then
    if [[ " ${command_line_args[*]} " == *" --help "* || " ${command_line_args[*]} " == *" -h "* ]]; then
        display_logo
    fi
else
    display_logo
fi
