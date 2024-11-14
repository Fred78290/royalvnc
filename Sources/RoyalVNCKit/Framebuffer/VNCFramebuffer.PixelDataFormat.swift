#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension VNCFramebuffer {
    enum PixelDataFormat {
        case normal
        case tight
    }
}
