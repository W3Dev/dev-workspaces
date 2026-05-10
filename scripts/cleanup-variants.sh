#!/bin/bash
# Script to clean up generated variants (keeping only core)

set -euo pipefail

echo "This script will remove all generated variants, keeping only core Dockerfiles."
echo "Are you sure you want to continue? (y/N)"
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Remove all non-core directories
for stack_dir in */; do
    stack=$(basename "$stack_dir")
    if [[ "$stack" =~ ^(nextjs|flutter|react-native|python|golang|bun|deno|expo|android)$ ]]; then
        for version_dir in "$stack_dir"*/; do
            version=$(basename "$version_dir")
            # Remove gitpod, code-server, devcontainer directories
            for variant in gitpod code-server devcontainer; do
                if [[ -d "${version_dir}${variant}" ]]; then
                    echo "Removing ${version_dir}${variant}"
                    rm -rf "${version_dir}${variant}"
                fi
            done
        done
    fi
done

echo "Cleanup complete! Only core Dockerfiles remain."
echo "Run './scripts/generate-variants.sh all' to regenerate all variants."