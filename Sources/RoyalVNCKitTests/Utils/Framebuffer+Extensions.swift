#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import RoyalVNCKit

extension VNCFramebuffer {
    var data: Data {
        .init(bytes: surfaceAddress,
              count: surfaceByteCount)
    }
}
