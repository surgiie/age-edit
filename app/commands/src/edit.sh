#!/bin/bash

# Variables from bashly args
secret_name="${args[secret_name]}"
namespace="${args[--namespace]:-default}"
key="${args[--key]:-}"
ext="${args[--ext]:-txt}"
use_passphrase=true

# Set use_passphrase based on whether key was provided
if [ -n "$key" ]; then
    use_passphrase=false
fi

if [ -z "${EDITOR:-}" ]; then
    error "No EDITOR environment variable set. Please set it to your preferred text editor." 1
fi

# Strip .age extension if provided
secret_name="${secret_name%.age}"

# Validate secret name format
validate_secret_name "$secret_name"

context="$(get_cli_context)"

secret_path=$(age_edit_context_path "items/$namespace/${secret_name}.age")

if [ ! -f "$secret_path" ]; then
    error "Secret with name '$secret_name' does not exist in namespace '$namespace'." 1
fi

# Validate the key exists
if [ -n "$key" ]; then
    if [ -f "$key" ]; then
        if ! age-keygen -y "$key" &>/dev/null; then
            error "Invalid identity file: $key" 1
        fi
    else
        error "Key must be a path to an identity file for decryption." 1
    fi
fi

# Decrypt the secret
rm -rf "$(tmp_path)"
mkdir -p "$(tmp_path "$context")"
tmp_file=$(mktemp $(tmp_path "$context/XXXXXX.$ext"))
trap 'rm -f "$tmp_file"' EXIT SIGINT SIGTERM

info "Decrypting:"
decrypt_file "$secret_path" "$key" "$use_passphrase" >"$tmp_file"

printf "\033[1A\033[2K"

$EDITOR "$tmp_file"

# Check if file has any content
if [ ! -s "$tmp_file" ]; then
    error "No contents provided." 1
fi

info "Encrypting:"
encrypted_contents=$(encrypt_file "$tmp_file" "$key" "$use_passphrase")
printf "\033[1A\033[2K"

echo "$encrypted_contents" >"$secret_path"

success "Updated secret '$secret_name' in namespace '$namespace' in context '$context'."
