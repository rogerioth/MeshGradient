#!/bin/bash

# Exit if any command fails
set -e

echo "🏗 Building Swift package..."

# Clean any existing build artifacts
swift package clean

# Build the package
swift build

# Run tests
echo "🧪 Running tests..."
swift test

echo "✅ Build and tests completed successfully!" 