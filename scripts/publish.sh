#!/bin/bash

# Exit if any command fails
set -e

# Check if a version tag was provided
if [ $# -eq 0 ]; then
    echo "❌ Error: No version tag provided"
    echo "Usage: ./publish.sh <version-tag>"
    echo "Example: ./publish.sh 1.0.0"
    exit 1
fi

VERSION=$1

echo "📦 Publishing version $VERSION..."

# Ensure working directory is clean
if [[ -n $(git status -s) ]]; then
    echo "❌ Error: Working directory is not clean. Please commit all changes first."
    exit 1
fi

# Create and push the tag
git tag $VERSION
git push origin $VERSION

echo "✅ Successfully published version $VERSION!" 