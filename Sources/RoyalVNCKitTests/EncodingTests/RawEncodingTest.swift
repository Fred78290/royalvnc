#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import XCTest

@testable import RoyalVNCKit

class RawEncodingTest: XCTestCase {
    let encoding = VNCProtocol.RawEncoding()
    
    func createSetup() throws -> EncodingTestSetup {
        try .init(encoding: encoding,
                  colorDepth: .depth24Bit,
                  framebufferSize: .init(width: 4, height: 4))
    }
    
    func testRawEncoding() async throws {
        let setup = try createSetup()
        
        let datas: [FrameEncodingRectangleTestData] = [
            .init(x: 0, y: 0, width: 2, height: 2,
                  encodingType: setup.encodingType, data: [
                0xff, 0x00, 0x00, 0,
                0x00, 0xff, 0x00, 0,
                0x00, 0xff, 0x00, 0,
                0xff, 0x00, 0x00, 0
            ]),
            .init(x: 2, y: 0, width: 2, height: 2,
                  encodingType: setup.encodingType, data: [
                0x00, 0x00, 0xff, 0,
                0x00, 0x00, 0xff, 0,
                0x00, 0x00, 0xff, 0,
                0x00, 0x00, 0xff, 0
            ]),
            .init(x: 0, y: 2, width: 4, height: 1,
                  encodingType: setup.encodingType, data: [
                0xee, 0x00, 0xff, 0,
                0x00, 0xee, 0xff, 0,
                0xaa, 0xee, 0xff, 0,
                0xab, 0xee, 0xff, 0
            ]),
            .init(x: 0, y: 3, width: 4, height: 1,
                  encodingType: setup.encodingType, data: [
                0xee, 0x00, 0xff, 0,
                0x00, 0xee, 0xff, 0,
                0xaa, 0xee, 0xff, 0,
                0xab, 0xee, 0xff, 0
            ])
        ]
        
        let connection = datas.connection
        
        for data in datas {
            try await encoding.decodeRectangle(data.rectangle,
                                               framebuffer: setup.framebuffer,
                                               connection: connection,
                                               logger: setup.logger)
        }
        
        let expectedData = Data([
            0xff, 0x00, 0x00, 255, 0x00, 0xff, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255,
            0x00, 0xff, 0x00, 255, 0xff, 0x00, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255,
            0xee, 0x00, 0xff, 255, 0x00, 0xee, 0xff, 255, 0xaa, 0xee, 0xff, 255, 0xab, 0xee, 0xff, 255,
            0xee, 0x00, 0xff, 255, 0x00, 0xee, 0xff, 255, 0xaa, 0xee, 0xff, 255, 0xab, 0xee, 0xff, 255
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    // TODO: Currently fails. Maybe because we don't set a color map?
//    func testRawEncodingInLowColorMode() async throws {
//        let setup = try createSetup()
//        
//        let datas: [FrameEncodingRectangleTestData] = [
//            .init(x: 0, y: 0, width: 2, height: 2,
//                  encodingType: setup.encodingType, data: [
//                0x30, 0x30, 0x30, 0x30
//            ]),
//            
//            .init(x: 2, y: 0, width: 2, height: 2,
//                  encodingType: setup.encodingType, data: [
//                0x0c, 0x0c, 0x0c, 0x0c
//            ]),
//            
//            .init(x: 0, y: 2, width: 4, height: 1,
//                  encodingType: setup.encodingType, data: [
//                0x0c, 0x0c, 0x30, 0x30
//            ]),
//            
//            .init(x: 0, y: 3, width: 4, height: 1,
//                  encodingType: setup.encodingType, data: [
//                0x0c, 0x0c, 0x30, 0x30
//            ])
//        ]
//        
//        let connection = datas.connection
//        
//        for data in datas {
//            try await encoding.decodeRectangle(data.rectangle,
//                                               framebuffer: setup.framebuffer,
//                                               connection: connection,
//                                               logger: setup.logger)
//        }
//        
//        let expectedData = Data([
//            0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255, 0x00, 0xff, 0x00, 255, 0x00, 0xff, 0x00, 255,
//            0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255, 0x00, 0xff, 0x00, 255, 0x00, 0xff, 0x00, 255,
//            0x00, 0xff, 0x00, 255, 0x00, 0xff, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255,
//            0x00, 0xff, 0x00, 255, 0x00, 0xff, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255
//        ])
//        
//        let actualData = setup.framebuffer.data
//
//        XCTAssertEqual(expectedData, actualData)
//    }
}
