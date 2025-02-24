import Quick
import Nimble
import Metal
@testable import MeshGradient

class MTLBufferPoolSpec: QuickSpec {
    override class func spec() {
        fdescribe("MTLBufferPool") {
            var device: MTLDevice!
            var bufferPool: MTLBufferPool!
            
            beforeEach {
                device = MTLCreateSystemDefaultDevice()
                bufferPool = MTLBufferPool(device: device)
            }
            
            context("when requesting buffers") {
                it("should create new buffers") {
                    let buffer = bufferPool[1024, .storageModeShared]
                    expect(buffer).toNot(beNil())
                    expect(buffer?.length).to(equal(1024))
                }
                
                it("should reuse buffers with same parameters") {
                    let buffer1 = bufferPool[1024, .storageModeShared]
                    bufferPool[1024, .storageModeShared] = buffer1
                    let buffer2 = bufferPool[1024, .storageModeShared]
                    
                    expect(buffer1).toNot(beNil())
                    expect(buffer2).toNot(beNil())
                    expect(buffer1?.length).to(equal(buffer2?.length))
                    expect(buffer1?.contents()).to(equal(buffer2?.contents()))
                }
                
                it("should create different buffers for different sizes") {
                    let buffer1 = bufferPool[1024, .storageModeShared]
                    let buffer2 = bufferPool[2048, .storageModeShared]
                    
                    expect(buffer1).toNot(beNil())
                    expect(buffer2).toNot(beNil())
                    expect(buffer1?.length).toNot(equal(buffer2?.length))
                }
                
                it("should create different buffers for different options") {
                    let buffer1 = bufferPool[1024, .storageModeShared]
                    let buffer2 = bufferPool[1024, .storageModePrivate]
                    
                    expect(buffer1).toNot(beNil())
                    expect(buffer2).toNot(beNil())
                    expect(buffer1?.resourceOptions).toNot(equal(buffer2?.resourceOptions))
                }
            }
            
            context("when handling invalid requests") {
                it("should handle zero length") {
                    let buffer = bufferPool[0, .storageModeShared]
                    expect(buffer).to(beNil())
                }
                
                it("should handle excessive length") {
                    let buffer = bufferPool[Int.max, .storageModeShared]
                    expect(buffer).to(beNil())
                }
            }
        }
    }
} 