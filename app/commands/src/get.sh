secret_name="${args[secret_name]}"
namespace="${args[--namespace]:-default}"
key="${args[--key]:-}"
use_passphrase=true

# Set use_passphrase based on whether key was provided
if [ -n "$key" ]; then
    use_passphrase=false
fi

secret_name="${secret_name%.age}" # Strip .age if provided
validate_secret_name "$secret_name"

# Build paths
context="$(get_cli_context)"

secret_path=$(age_edit_context_path "items/$namespace/${secret_name}.age")

# Check secret exists
if [ ! -f "$secret_path" ]; then
    error "Secret with name '$secret_name' does not exist in namespace '$namespace'." 1
fi

# Validate key if provided
if [ -n "$key" ]; then
    if [ -f "$key" ]; then
        if ! age-keygen -y "$key" &>/dev/null; then
            error "Invalid identity file: $key" 1
        fi
    else
        error "Key must be a path to an identity file for decryption." 1
    fi
fi

# Decrypt and output to console
decrypt_file "$secret_path" "$key" "$use_passphrase"
