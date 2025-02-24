import Quick
import Nimble
import simd
@testable import MeshGradient

final class MeshAnimatorSpec: QuickSpec {
    override class func spec() {
        describe("MeshAnimator") {
            var animator: MeshAnimator!
            var initialGrid: Grid<ControlPoint>!
            var configuration: MeshAnimator.Configuration!
            var randomizer: MeshRandomizer!
            
            beforeEach {
                // Create a simple 2x2 grid
                initialGrid = Grid(repeating: ControlPoint(), width: 2, height: 2)
                randomizer = MeshRandomizer()
                configuration = MeshAnimator.Configuration(
                    framesPerSecond: 60,
                    animationSpeedRange: 2...5,
                    meshRandomizer: randomizer
                )
                animator = MeshAnimator(grid: initialGrid, configuration: configuration)
            }
            
            afterEach {
                animator = nil
                initialGrid = nil
                configuration = nil
                randomizer = nil
            }
            
            context("when initialized") {
                it("should have a valid grid") {
                    expect(animator.grid).toNot(beNil())
                    expect(animator.grid.width) == initialGrid.width
                    expect(animator.grid.height) == initialGrid.height
                }
                
                it("should have correct configuration") {
                    expect(animator.configuration.framesPerSecond) == 60
                    expect(animator.configuration.animationSpeedRange.lowerBound) == 2
                    expect(animator.configuration.animationSpeedRange.upperBound) == 5
                }
            }
            
            context("when accessing grid") {
                it("should update grid state") {
                    let firstGrid = animator.grid
                    let secondGrid = animator.grid
                    
                    var hasChanges = false
                    for x in 0..<animator.grid.width {
                        for y in 0..<animator.grid.height {
                            if firstGrid[x, y] != secondGrid[x, y] {
                                hasChanges = true
                                break
                            }
                        }
                    }
                    
                    expect(hasChanges).to(beTrue())
                }
            }
        }
        
        describe("MeshRandomizer") {
            var randomizer: MeshRandomizer!
            var grid: Grid<ControlPoint>!
            
            beforeEach {
                let colorGrid = Grid(repeating: MeshGenerator.Color(1, 0, 0), width: 3, height: 3)
                grid = MeshGenerator.generate(colorDistribution: colorGrid)
                randomizer = MeshRandomizer()
            }
            
            it("should generate random colors") {
                let color = MeshRandomizer.randomColor()
                expect(color.x).to(beGreaterThanOrEqualTo(0))
                expect(color.x).to(beLessThanOrEqualTo(1))
                expect(color.y).to(beGreaterThanOrEqualTo(0))
                expect(color.y).to(beLessThanOrEqualTo(1))
                expect(color.z).to(beGreaterThanOrEqualTo(0))
                expect(color.z).to(beLessThanOrEqualTo(1))
            }
            
            context("when randomizing the mesh") {
                it("should modify locations") {
                    var location = simd_float2(0, 0)
                    let originalLocation = location
                    randomizer.locationRandomizer(&location, 1, 1, 3, 3)
                    expect(location).toNot(equal(originalLocation))
                }
                
                it("should modify turbulency") {
                    var tangent = simd_float2(0, 0)
                    let originalTangent = tangent
                    randomizer.turbulencyRandomizer(&tangent, 1, 1, 3, 3)
                    expect(tangent).toNot(equal(originalTangent))
                }
                
                it("should modify colors") {
                    var color = simd_float3(0, 0, 0)
                    let originalColor = color
                    let initialColor = simd_float3(1, 0, 0)
                    randomizer.colorRandomizer(&color, initialColor, 1, 1, 3, 3)
                    expect(color).toNot(equal(originalColor))
                }
            }
        }
    }
} 