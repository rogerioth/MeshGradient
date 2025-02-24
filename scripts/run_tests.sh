#!/bin/bash

# Print a header
echo "🧪 Running MeshGradient Tests..."
echo "================================"

# Run the tests with color output
swift test --enable-test-discovery

# Get the exit code
TEST_EXIT_CODE=$?

echo "================================"

# Check if tests passed or failed
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✅ Tests completed successfully!"
else
    echo "❌ Tests failed with exit code: $TEST_EXIT_CODE"
fi

exit $TEST_EXIT_CODE 