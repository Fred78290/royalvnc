#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import XCTest

@testable import RoyalVNCKit

class RawEncodingTest: XCTestCase {
    struct MockData {
        let rectangle: VNCProtocol.Rectangle
        let data: Data
        
        init(x: UInt16, y: UInt16, width: UInt16, height: UInt16, data: [UInt8]) {
            self.rectangle = .init(xPosition: x, yPosition: y,
                                   width: width, height: height,
                                   encodingType: VNCFrameEncodingType.raw.rawValue.int32Value!)
            
            self.data = .init(data)
        }
        
        var connection: NetworkConnectionReading {
            ReadableMockConnection(data: data)
        }
    }
    
    func testRawEncoding() async throws {
        let logger = VNCPrintLogger()
        let encoding = VNCProtocol.RawEncoding()
        
        let framebufferSize = VNCSize(width: 4, height: 4)
        
        let screens: [VNCScreen] = [
            .init(id: 0, frame: .init(location: .zero, size: framebufferSize))
        ]
        
        let pixelFormat = VNCProtocol.PixelFormat.init(depth: 24)
        
        let framebuffer = try VNCFramebuffer(logger: logger,
                                             size: framebufferSize,
                                             screens: screens,
                                             pixelFormat: pixelFormat)
        
        let datas: [MockData] = [
            .init(x: 0, y: 0, width: 2, height: 2, data: [
                0xff, 0x00, 0x00, 0,
                0x00, 0xff, 0x00, 0,
                0x00, 0xff, 0x00, 0,
                0xff, 0x00, 0x00, 0
            ]),
            
            .init(x: 2, y: 0, width: 2, height: 2, data: [
                0x00, 0x00, 0xff, 0,
                0x00, 0x00, 0xff, 0,
                0x00, 0x00, 0xff, 0,
                0x00, 0x00, 0xff, 0
            ]),
            
            .init(x: 0, y: 2, width: 4, height: 1, data: [
                0xee, 0x00, 0xff, 0,
                0x00, 0xee, 0xff, 0,
                0xaa, 0xee, 0xff, 0,
                0xab, 0xee, 0xff, 0
            ]),
            
            .init(x: 0, y: 3, width: 4, height: 1, data: [
                0xee, 0x00, 0xff, 0,
                0x00, 0xee, 0xff, 0,
                0xaa, 0xee, 0xff, 0,
                0xab, 0xee, 0xff, 0
            ])
        ]
        
        for data in datas {
            try await encoding.decodeRectangle(data.rectangle,
                                               framebuffer: framebuffer,
                                               connection: data.connection,
                                               logger: logger)
        }
        
        let expectedData = Data([
            0xff, 0x00, 0x00, 255, 0x00, 0xff, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255,
            0x00, 0xff, 0x00, 255, 0xff, 0x00, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255,
            0xee, 0x00, 0xff, 255, 0x00, 0xee, 0xff, 255, 0xaa, 0xee, 0xff, 255, 0xab, 0xee, 0xff, 255,
            0xee, 0x00, 0xff, 255, 0x00, 0xee, 0xff, 255, 0xaa, 0xee, 0xff, 255, 0xab, 0xee, 0xff, 255
        ])
        
        let actualData = Data(bytes: framebuffer.surfaceAddress,
                              count: framebuffer.surfaceByteCount)
        
        XCTAssertEqual(expectedData, actualData)
    }
}
