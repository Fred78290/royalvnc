#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import XCTest

@testable import RoyalVNCKit

class TightEncodingTest: XCTestCase {
    let encoding = VNCProtocol.TightEncoding()
    
    func createSetup() throws -> EncodingTestSetup {
        try .init(encoding: encoding,
                  colorDepth: .depth24Bit,
                  framebufferSize: .init(width: 4, height: 4))
    }
    
    // TODO: Not implemented yet
//    func testTightFill() async throws {
//        let setup = try createSetup()
//
//        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
//                                                  encodingType: setup.encodingType,
//                                                  data: [
//                                                    0x80, 0xff, 0x88, 0x44
//                                                  ])
//        
//        let connection = data.connection
//        
//        try await encoding.decodeRectangle(data.rectangle,
//                                           framebuffer: setup.framebuffer,
//                                           connection: connection,
//                                           logger: setup.logger)
//        
//        let expectedData = Data([
//            0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255,
//            0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255,
//            0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255,
//            0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255,
//        ])
//        
//        let actualData = setup.framebuffer.data
//        
//        XCTAssertEqual(expectedData, actualData)
//    }
}
