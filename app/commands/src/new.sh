secret_name="${args[secret_name]}"
namespace="${args[--namespace]}"
key="${args[--key]:-}"
ext="${args[--ext]}"
use_passphrase=true

# Set use_passphrase based on whether key was provided
if [ -n "$key" ]; then
    use_passphrase=false
fi

if [ -z "${EDITOR:-}" ]; then
    error "No EDITOR environment variable set. Please set it to your preferred text editor." 1
fi

# Validate secret name format
validate_secret_name "$secret_name"
context="$(get_cli_context)"

secret_path=$(age_edit_context_path "items/$namespace/$secret_name.age")

if [ -f "$secret_path" ]; then
    error "Secret with name '$secret_name' already exists in namespace '$namespace'." 1
fi

mkdir -p "$(dirname "$secret_path")"

# if a key is provided, validate it
if [ -n "$key" ]; then
    if [ -f "$key" ]; then
        if ! age-keygen -y "$key" &>/dev/null; then
            error "Invalid identity file: $key" 1
        fi
    elif [[ "$key" == age1* ]]; then
        # It's a public key - basic format validation
        # Age public keys are age1 followed by 58 bech32 characters
        if [[ ! "$key" =~ ^age1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]{58}$ ]]; then
            error "Invalid age public key format: $key" 1
        fi
    else
        error "Invalid key format. Must be an age public key (age1...) or path to identity file." 1
    fi
fi

rm -rf "$(tmp_path)"
mkdir -p "$(tmp_path "$context")"
tmp_file=$(mktemp $(tmp_path "$context/XXXXXX.$ext"))
trap 'rm -f "$tmp_file"' EXIT SIGINT SIGTERM

$EDITOR "$tmp_file"

# Check if file has any content
if [ ! -s "$tmp_file" ]; then
    error "No contents provided." 1
fi

info "Encrypting:"
encrypted_contents=$(encrypt_file "$tmp_file" "$key" "$use_passphrase")
printf "\033[1A\033[2K"

echo "$encrypted_contents" >"$secret_path"

success "Generated secret '$secret_name' in namespace '$namespace' in context '$context'."
