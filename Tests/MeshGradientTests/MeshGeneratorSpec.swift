import Quick
import Nimble
import simd
@testable import MeshGradient

class MeshGeneratorSpec: QuickSpec {
    override class func spec() {
        describe("MeshGenerator") {
            context("when generating a mesh") {
                it("should create a valid grid with control points") {
                    let colorGrid = Grid(repeating: MeshGenerator.Color(1, 0, 0), width: 4, height: 4)
                    let grid = MeshGenerator.generate(colorDistribution: colorGrid)
                    
                    expect(grid.width).to(equal(4))
                    expect(grid.height).to(equal(4))
                    expect(grid.elements.count).to(equal(16))
                }
                
                it("should create control points with correct locations") {
                    let colorGrid = Grid(repeating: MeshGenerator.Color(1, 0, 0), width: 2, height: 2)
                    let grid = MeshGenerator.generate(colorDistribution: colorGrid)
                    
                    // Check corners
                    let topLeft = grid[0, 0]
                    let topRight = grid[1, 0]
                    let bottomLeft = grid[0, 1]
                    let bottomRight = grid[1, 1]
                    
                    expect(topLeft.location.x).to(beCloseTo(-1))
                    expect(topLeft.location.y).to(beCloseTo(-1))
                    
                    expect(topRight.location.x).to(beCloseTo(1))
                    expect(topRight.location.y).to(beCloseTo(-1))
                    
                    expect(bottomLeft.location.x).to(beCloseTo(-1))
                    expect(bottomLeft.location.y).to(beCloseTo(1))
                    
                    expect(bottomRight.location.x).to(beCloseTo(1))
                    expect(bottomRight.location.y).to(beCloseTo(1))
                }
                
                it("should preserve color distribution") {
                    let colors = [
                        MeshGenerator.Color(1, 0, 0),
                        MeshGenerator.Color(0, 1, 0),
                        MeshGenerator.Color(0, 0, 1),
                        MeshGenerator.Color(1, 1, 1)
                    ]
                    var colorGrid = Grid(repeating: colors[0], width: 2, height: 2)
                    for x in 0..<2 {
                        for y in 0..<2 {
                            colorGrid[x, y] = colors[y * 2 + x]
                        }
                    }
                    let grid = MeshGenerator.generate(colorDistribution: colorGrid)
                    
                    expect(grid[0, 0].color).to(equal(colors[0]))
                    expect(grid[1, 0].color).to(equal(colors[1]))
                    expect(grid[0, 1].color).to(equal(colors[2]))
                    expect(grid[1, 1].color).to(equal(colors[3]))
                }
                
                it("should handle grid access") {
                    let colorGrid = Grid(repeating: MeshGenerator.Color(1, 0, 0), width: 3, height: 3)
                    let grid = MeshGenerator.generate(colorDistribution: colorGrid)
                    
                    // Valid access
                    let point = grid[0, 0]
                    expect(point.location.x).to(beCloseTo(-1))
                    expect(point.location.y).to(beCloseTo(-1))
                    
                    // Out of bounds access should crash in debug, but we'll test bounds
                    expect(grid.width).to(equal(3))
                    expect(grid.height).to(equal(3))
                }
            }
        }
        
        describe("ControlPoint") {
            it("should initialize with correct values") {
                let location = simd_float2(0.5, 0.5)
                let color = simd_float3(1, 0, 0)
                let point = ControlPoint(color: color, location: location)
                
                expect(point.location.x).to(equal(0.5))
                expect(point.location.y).to(equal(0.5))
                expect(point.color.x).to(equal(1))
                expect(point.color.y).to(equal(0))
                expect(point.color.z).to(equal(0))
            }
            
            it("should initialize with default values") {
                let point = ControlPoint()
                
                expect(point.location.x).to(equal(0))
                expect(point.location.y).to(equal(0))
                expect(point.color.x).to(equal(0))
                expect(point.color.y).to(equal(0))
                expect(point.color.z).to(equal(0))
                expect(point.uTangent.x).to(equal(0))
                expect(point.uTangent.y).to(equal(0))
                expect(point.vTangent.x).to(equal(0))
                expect(point.vTangent.y).to(equal(0))
            }
        }
    }
} 