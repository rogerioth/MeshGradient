// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "MeshGradient",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.macCatalyst(.v13),
		.tvOS(.v13),
	],
    products: [
        .library(
            name: "MeshGradient",
            targets: ["MeshGradient"]),
		.library(name: "MeshGradientCHeaders",
				 targets: ["MeshGradientCHeaders"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.0.0")
    ],
    targets: [
        .target(
            name: "MeshGradient",
            dependencies: ["MeshGradientCHeaders"],
            exclude: [
                "MTLComputeHermitPatchMatrix.metal",
                "MTLComputeMeshTrianglePrimitives.metal",
                "MTLComputeNoise.metal",
                "MTLComputeShuffleCoefficients.metal",
                "MTLDrawMeshTriangles.metal"
            ],
            resources: [
                .copy("DummyResources/"),
                // Compiled Metal files from root
                .process("MTLComputeHermitPatchMatrix.air"),
                .process("MTLComputeMeshTrianglePrimitives.air"),
                .process("MTLComputeNoise.air"),
                .process("MTLComputeShuffleCoefficients.air"),
                .process("MTLDrawMeshTriangles.air"),
                // Resources directory Metal files
                .process("Resources/MTLComputeHermitPatchMatrix.metal"),
                .process("Resources/MTLComputeMeshTrianglePrimitives.metal"),
                .process("Resources/MTLComputeNoise.metal"),
                .process("Resources/MTLComputeShuffleCoefficients.metal"),
                .process("Resources/MTLDrawMeshTriangles.metal"),
                .process("Resources/default.metallib")
            ]
        ),
		.target(name: "MeshGradientCHeaders"),
        .testTarget(
            name: "MeshGradientTests",
            dependencies: [
                "MeshGradient",
                "Quick",
                "Nimble"
            ]
        )
    ]
)
