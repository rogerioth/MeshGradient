import Quick
import Nimble
import Metal
import MetalKit
@testable import MeshGradient

final class MetalRendererSpec: QuickSpec {
    override class func spec() {
        var renderer: MetalMeshRenderer!
        var device: MTLDevice!
        var mtkView: MTKView!
        var meshDataProvider: MeshDataProvider!
        
        beforeEach {
            device = MTLCreateSystemDefaultDevice()
            guard let device = device else {
                fail("Failed to create Metal device")
                return
            }
            
            // Create MTKView
            mtkView = MTKView(frame: .zero, device: device)
            mtkView.colorPixelFormat = .bgra8Unorm
            
            // Create test grid and data provider
            let grid = Grid(repeating: ControlPoint(), width: 2, height: 2)
            let randomizer = MeshRandomizer()
            let configuration = MeshAnimator.Configuration(
                framesPerSecond: 60,
                animationSpeedRange: 2...5,
                meshRandomizer: randomizer
            )
            meshDataProvider = MeshAnimator(grid: grid, configuration: configuration)
            
            renderer = MetalMeshRenderer(
                metalKitView: mtkView,
                meshDataProvider: meshDataProvider,
                viewportSize: vector_float2(512, 512),
                grainAlpha: 0.1
            )
        }
        
        afterEach {
            renderer = nil
            device = nil
            mtkView = nil
            meshDataProvider = nil
        }
        
        it("should initialize successfully") {
            expect(renderer).toNot(beNil())
        }
        
        it("should have correct viewport size") {
            expect(renderer.viewportSize) == vector_float2(512, 512)
        }
        
        it("should have correct grain alpha") {
            expect(renderer.grainAlpha) == 0.1
        }
        
        context("when Metal is available") {
            it("should have valid Metal device") {
                expect(device).toNot(beNil())
            }
            
            it("should have valid command queue") {
                expect(renderer.commandQueue).toNot(beNil())
            }
            
            it("should have valid buffer pool") {
                expect(renderer.bufferPool).toNot(beNil())
            }
        }
    }
}