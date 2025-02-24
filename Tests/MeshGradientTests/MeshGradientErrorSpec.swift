import Quick
import Nimble
@testable import MeshGradient

class MeshGradientErrorSpec: QuickSpec {
    override class func spec() {
        describe("MeshGradientError") {
            it("should provide meaningful error descriptions") {
                let error = MeshGradientError.metalFunctionNotFound(name: "testFunction")
                expect(error.localizedDescription).toNot(beEmpty())
            }
            
            it("should include function name in error") {
                let functionName = "testFunction"
                let error = MeshGradientError.metalFunctionNotFound(name: functionName)
                expect(error.localizedDescription).to(contain(functionName))
            }
        }
    }
} 