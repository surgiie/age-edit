#!/bin/bash
set -euo pipefail
echo "Generating age-edit cli script with bashly..."

# Check if docker is available
if command -v docker >/dev/null 2>&1; then
    docker run --rm -it --user "$(id -u):$(id -g)" --volume "$PWD:/app" dannyben/bashly generate
elif command -v bashly >/dev/null 2>&1; then
    bashly generate
else
    echo "ERROR: Neither docker nor bashly gem found!"
    echo ""
    echo "Please install one of the following:"
    echo ""
    echo "Option 1 - Docker:"
    echo "  Install Docker and ensure it's running"
    echo "  For WSL2: Enable WSL integration in Docker Desktop settings"
    echo ""
    echo "Option 2 - Ruby gem:"
    echo "  gem install bashly"
    echo ""
    exit 1
fi

echo ""
echo "✓ Successfully generated age-edit executable"
echo ""
echo "You can now run: ./age-edit --help"
