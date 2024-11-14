#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

// TODO: Untested
extension VNCProtocol {
    struct JPEGCompressionLevelEncoding: VNCPseudoEncoding {
        /// Set to any value between (including) VNCPseudoEncodingType.jpegCompressionLevel1 to VNCPseudoEncodingType.jpegCompressionLevel10
        /// Level 1 represents the lowest JPEG quality, Level 10 the highest JPEG quality
        let encodingType: VNCEncodingType
    }
}
