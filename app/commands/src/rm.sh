#!/bin/bash

# Variables from bashly args
secret_name="${args[secret_name]}"
namespace="${args[--namespace]:-default}"
force="${args[--force]:-}"

context="$(get_cli_context)"

secret_name="${secret_name%.age}" # Strip .age if provided
validate_secret_name "$secret_name"
secret_path=$(age_edit_context_path "items/$namespace/${secret_name}.age")

if [ ! -f "$secret_path" ]; then
    error "Secret with name '$secret_name' doesnt exist in namespace '$namespace'." 1
fi

if [[ -z "$force" ]] && ! confirm "Are you sure you want to remove '$secret_name' from your stored secrets?"; then
    warning "Aborted." 1
fi

rm -f "$secret_path"
success "Removed secret '$secret_name' in namespace '$namespace' in context '$context'."
