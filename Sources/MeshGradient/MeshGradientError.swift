import Foundation

public enum MeshGradientError: LocalizedError {
    case metalFunctionNotFound(name: String)
    
    public var errorDescription: String? {
        switch self {
        case .metalFunctionNotFound(let name):
            return "Metal function '\(name)' not found"
        }
    }
}
