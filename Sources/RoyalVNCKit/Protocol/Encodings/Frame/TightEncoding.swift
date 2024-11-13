#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension VNCProtocol {
    struct TightEncoding: VNCFrameEncoding {
        let encodingType = VNCFrameEncodingType.tight.rawValue
    }
}

extension VNCProtocol.TightEncoding {
    func decodeRectangle(_ rectangle: VNCProtocol.Rectangle,
                         framebuffer: VNCFramebuffer,
                         connection: NetworkConnectionReading,
                         logger: VNCLogger) async throws {
        fatalError("Not implemented")
    }
}

private extension VNCProtocol.TightEncoding {
    
}
