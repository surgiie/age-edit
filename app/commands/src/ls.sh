#!/bin/bash

# Variables from bashly args
namespace="${args[--namespace]:-}"

declare -A secrets=()
context="$(get_cli_context)"

if [ -n "$namespace" ]; then
    secrets_path=$(age_edit_context_path "items/$namespace")
else
    secrets_path=$(age_edit_context_path "items")
fi

for file in $(find "$secrets_path" -type f 2>/dev/null); do
    namespace="$(basename "$(dirname "$file")")"
    name="$(basename "$file")"
    name="${name%.age}"
    if [[ -z ${secrets[$namespace]+_} ]]; then
        secrets[$namespace]=""
    fi

    secrets[$namespace]="${secrets[$namespace]} $name"
done

if [ ${#secrets[@]} -eq 0 ]; then
    warning "No secret items found in context '$(green_bold "$context")'." 1
fi

for ns in "${!secrets[@]}"; do
    items=()
    for item in ${secrets[$ns]}; do
        items+=("$item")
    done

    max_len=0
    item=""
    border=""
    min_width=40

    # Find the longest string
    for item in "${items[@]}"; do
        ((${#item} > max_len)) && max_len=${#item}
    done

    ((max_len < min_width)) && max_len=$min_width
    # Build border
    border="  +-$(printf '%*s' "$max_len" '' | tr ' ' '-')-+"
    # Print table
    echo "$border"
    echo "  | $(printf '%-*s' "$max_len" "Namespace: $ns") |"
    echo "$border"
    for item in "${items[@]}"; do
        printf "  | %-${max_len}s |\n" "$item"
    done
    echo "$border"

    echo -e "\n"
done
