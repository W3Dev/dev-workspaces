#!/bin/bash
# Helper script to add a new version to an existing stack

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <stack> <new-version>"
    echo "Example: $0 flutter v3.33"
    exit 1
fi

STACK=$1
NEW_VERSION=$2

# Check if stack exists
if [[ ! -d "$STACK" ]]; then
    echo "Error: Stack '$STACK' does not exist"
    exit 1
fi

# Check if version already exists
if [[ -d "$STACK/$NEW_VERSION" ]]; then
    echo "Error: Version '$NEW_VERSION' already exists for stack '$STACK'"
    exit 1
fi

# Find the latest existing version
LATEST_VERSION=$(ls -d "$STACK"/v* 2>/dev/null | sort -V | tail -1 | xargs basename)

if [[ -z "$LATEST_VERSION" ]]; then
    echo "Error: No existing versions found for stack '$STACK'"
    exit 1
fi

echo "Creating new version $NEW_VERSION based on $LATEST_VERSION..."

# Create new version directory
mkdir -p "$STACK/$NEW_VERSION/core"

# Copy core Dockerfile from latest version
cp "$STACK/$LATEST_VERSION/core/Dockerfile" "$STACK/$NEW_VERSION/core/Dockerfile"

# Update version references in the new Dockerfile
case $STACK in
    flutter)
        # Extract version number without 'v' prefix
        OLD_NUM=${LATEST_VERSION#v}
        NEW_NUM=${NEW_VERSION#v}
        sed -i '' "s/$LATEST_VERSION/$NEW_VERSION/g" "$STACK/$NEW_VERSION/core/Dockerfile"
        sed -i '' "s/$OLD_NUM/$NEW_NUM/g" "$STACK/$NEW_VERSION/core/Dockerfile"
        ;;
    nextjs|react-native|expo|python|golang|bun|deno)
        # Simple version replacement
        sed -i '' "s/$LATEST_VERSION/$NEW_VERSION/g" "$STACK/$NEW_VERSION/core/Dockerfile"
        # Also update version-specific references
        OLD_NUM=${LATEST_VERSION#v}
        NEW_NUM=${NEW_VERSION#v}
        sed -i '' "s/@$OLD_NUM/@$NEW_NUM/g" "$STACK/$NEW_VERSION/core/Dockerfile"
        sed -i '' "s/\b$OLD_NUM\b/$NEW_NUM/g" "$STACK/$NEW_VERSION/core/Dockerfile"
        ;;
esac

echo "Created core Dockerfile for $STACK $NEW_VERSION"
echo ""
echo "IMPORTANT: Please update the following in $STACK/$NEW_VERSION/core/Dockerfile:"
echo "1. Check and update any hardcoded version numbers"
echo "2. Update any deprecated features or commands"
echo "3. Add any new features specific to this version"
echo ""
echo "After updating the core Dockerfile, run:"
echo "  ./scripts/generate-variants.sh $STACK $NEW_VERSION"
echo ""
echo "Don't forget to update:"
echo "1. $STACK/README.md - Add the new version to the versions table"
echo "2. Main README.md - Update if this is the latest version"