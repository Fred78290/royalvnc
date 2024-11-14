#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import RoyalVNCKit

class EncodingTestSetup {
    let logger: VNCLogger
    let encoding: VNCEncoding
    let encodingType: VNCEncodingType
    let colorDepth: VNCConnection.Settings.ColorDepth
    let framebuffer: VNCFramebuffer
    
    init(encoding: VNCEncoding,
         colorDepth: VNCConnection.Settings.ColorDepth,
         framebufferSize: VNCSize) throws {
        self.logger = VNCPrintLogger()
        self.logger.isDebugLoggingEnabled = true
        
        self.encoding = encoding
        self.encodingType = encoding.encodingType
        self.colorDepth = colorDepth
        
        let screens: [VNCScreen] = [
            .init(id: 0, frame: .init(location: .zero, size: framebufferSize))
        ]
        
        let pixelFormat = VNCProtocol.PixelFormat(depth: colorDepth.rawValue)
        
        self.framebuffer = try VNCFramebuffer(logger: logger,
                                              size: framebufferSize,
                                              screens: screens,
                                              pixelFormat: pixelFormat)
    }
}
