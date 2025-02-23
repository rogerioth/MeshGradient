# MeshGradient

A powerful Metal-based implementation for creating beautiful mesh gradients in Swift. This library provides an easy-to-use interface for generating stunning, animated mesh gradients for your iOS, macOS, tvOS, and Mac Catalyst applications.

![Mesh gradient gif](Files/mesh.gif)

## Features

- 🎨 Beautiful mesh gradient generation
- ⚡️ Metal-powered performance
- 🔄 Support for both static and animated gradients
- 📱 Cross-platform support (iOS 13+, macOS 10.15+, tvOS 13+, Mac Catalyst 13+)
- 🎮 SwiftUI and UIKit support
- 🎲 Built-in randomization utilities

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/rogerioth/MeshGradient", from: "1.0.9")
]
```

## Usage

### Basic Implementation

#### SwiftUI - Static Gradient

```swift
struct MyStaticGrid: View {
    var body: some View {
        MeshGradient(grid: generatePlainGrid())
    }
}
```

#### SwiftUI - Animated Gradient

```swift
struct MyAnimatedGrid: View {
    @State var meshRandomizer = MeshRandomizer(
        colorRandomizer: MeshRandomizer.arrayBasedColorRandomizer(
            availableColors: meshColors
        )
    )

    var body: some View {
        MeshGradient(
            initialGrid: generatePlainGrid(),
            animatorConfiguration: .init(
                animationSpeedRange: 2...4,
                meshRandomizer: meshRandomizer
            )
        )
    }
}
```

### Generating Custom Meshes

The mesh is generated using a grid of `ControlPoint`s with the following parameters:

- **Colors**: Define the gradient colors using `SIMD3<Float>`
- **Locations**: Control points in metal coordinate space (-1...1)
- **Turbulence**: Control mesh distortion using `uTangent` and `vTangent`

Example implementation:

```swift
typealias MeshColor = SIMD3<Float>

var meshRandomizer = MeshRandomizer(
    colorRandomizer: MeshRandomizer.arrayBasedColorRandomizer(
        availableColors: meshColors
    )
)

func generatePlainGrid(size: Int = 6) -> Grid<ControlPoint> {
    let preparationGrid = Grid<MeshColor>(repeating: .zero, width: size, height: size)
    var result = MeshGenerator.generate(colorDistribution: preparationGrid)
    
    for y in stride(from: 0, to: result.width, by: 1) {
        for x in stride(from: 0, to: result.height, by: 1) {
            meshRandomizer.locationRandomizer(&result[x, y].location, x, y, result.width, result.height)
            meshRandomizer.turbulencyRandomizer(&result[x, y].uTangent, x, y, result.width, result.height)
            meshRandomizer.turbulencyRandomizer(&result[x, y].vTangent, x, y, result.width, result.height)
            meshRandomizer.colorRandomizer(&result[x, y].color, result[x, y].color, x, y, result.width, result.height)
        }
    }
    
    return result
}
```

### UIKit Implementation

For UIKit applications, use `MTKView` and `MetalMeshRenderer`. Check the SwiftUI `MeshGradient` implementation source code for reference on how to wrap `MTKView`.

## Scripts

### Publishing New Versions

The repository includes a publishing script to help manage releases:

```bash
./scripts/publish.sh <version-tag>
```

Example:
```bash
./scripts/publish.sh 1.0.0
```

The script will:
1. Verify that a version tag is provided
2. Check if the working directory is clean
3. Create and push the new version tag

## Requirements

- iOS 13.0+
- macOS 10.15+
- tvOS 13.0+
- Mac Catalyst 13.0+
- Swift 5.6+

## License

This project is licensed under the terms found in the [LICENSE](LICENSE) file.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.
