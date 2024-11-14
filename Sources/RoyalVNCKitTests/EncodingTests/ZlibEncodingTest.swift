#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import XCTest

@testable import RoyalVNCKit

class ZlibEncodingTest: XCTestCase {
    let encoding = VNCProtocol.ZlibEncoding(zStream: .init())
    
    func createSetup() throws -> EncodingTestSetup {
        try .init(encoding: encoding,
                  colorDepth: .depth24Bit,
                  framebufferSize: .init(width: 4, height: 4))
    }
    
    func testZlibEncoding() async throws {
        let setup = try createSetup()
        
        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
                                                  encodingType: setup.encodingType,
                                                  data: [
                                                    0x00, 0x00, 0x00, 0x23, /* length */
                                                    0x78, 0x01, 0xfa, 0xcf, 0x00, 0x04, 0xff, 0x61, 0x04, 0x90, 0x01, 0x41, 0x50, 0xc1, 0xff, 0x0c,
                                                    0xef, 0x40, 0x02, 0xef, 0xfe, 0x33, 0xac, 0x02, 0xe2, 0xd5, 0x40, 0x8c, 0xce, 0x07, 0x00, 0x00,
                                                    0x00, 0xff, 0xff
                                                  ])
        
        let connection = data.connection
        
        try await encoding.decodeRectangle(data.rectangle,
                                           framebuffer: setup.framebuffer,
                                           connection: connection,
                                           logger: setup.logger)
        
        let expectedData = Data([
            0xff, 0x00, 0x00, 255, 0x00, 0xff, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255,
            0x00, 0xff, 0x00, 255, 0xff, 0x00, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255,
            0xee, 0x00, 0xff, 255, 0x00, 0xee, 0xff, 255, 0xaa, 0xee, 0xff, 255, 0xab, 0xee, 0xff, 255,
            0xee, 0x00, 0xff, 255, 0x00, 0xee, 0xff, 255, 0xaa, 0xee, 0xff, 255, 0xab, 0xee, 0xff, 255
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
}
