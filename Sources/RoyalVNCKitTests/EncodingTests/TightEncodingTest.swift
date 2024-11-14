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
    
    func testTightFill() async throws {
        let setup = try createSetup()

        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
                                                  encodingType: setup.encodingType,
                                                  data: [
                                                    0x80, 0xff, 0x88, 0x44
                                                  ])
        
        let connection = data.connection
        
        try await encoding.decodeRectangle(data.rectangle,
                                           framebuffer: setup.framebuffer,
                                           connection: connection,
                                           logger: setup.logger)
        
        let expectedData = Data([
            0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255,
            0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255,
            0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255,
            0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255, 0xff, 0x88, 0x44, 255,
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    // TODO: Not implemented
//    func testTightUncompressedCopyRects() async throws {
//        let setup = try createSetup()
//        
//        let blueData: [UInt8] = [ 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0xff ]
//        let greenData: [UInt8] = [ 0x00, 0x00, 0xff, 0x00, 0x00, 0xff, 0x00 ]
//        
//        let datas: [FrameEncodingRectangleTestData] = [
//            .init(x: 0, y: 0, width: 2, height: 1,
//                  encodingType: setup.encodingType,
//                  data: blueData),
//            .init(x: 0, y: 1, width: 2, height: 1,
//                  encodingType: setup.encodingType,
//                  data: blueData),
//            .init(x: 2, y: 0, width: 2, height: 1,
//                  encodingType: setup.encodingType,
//                  data: greenData),
//            .init(x: 2, y: 1, width: 2, height: 1,
//                  encodingType: setup.encodingType,
//                  data: greenData),
//            .init(x: 0, y: 2, width: 2, height: 1,
//                  encodingType: setup.encodingType,
//                  data: greenData),
//            .init(x: 0, y: 3, width: 2, height: 1,
//                  encodingType: setup.encodingType,
//                  data: greenData),
//            .init(x: 2, y: 2, width: 2, height: 1,
//                  encodingType: setup.encodingType,
//                  data: blueData),
//            .init(x: 2, y: 3, width: 2, height: 1,
//                  encodingType: setup.encodingType,
//                  data: blueData),
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
//    
//    func testTightCompressedCopyRects() async throws {
//        let setup = try createSetup()
//
//        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
//                                                  encodingType: setup.encodingType,
//                                                  data: [
//                                                    // Control byte
//                                                    0x00,
//                                                    // Pixels (compressed)
//                                                    0x15,
//                                                    0x78, 0x9c, 0x63, 0x60, 0xf8, 0xcf, 0x00, 0x44,
//                                                    0x60, 0x82, 0x01, 0x99, 0x8d, 0x29, 0x02, 0xa6,
//                                                    0x00, 0x7e, 0xbf, 0x0f, 0xf1
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
//    
//    func testTightCompressedMonoRects() async throws {
//        let setup = try createSetup()
//
//        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
//                                                  encodingType: setup.encodingType,
//                                                  data: [
//                                                    // Control bytes
//                                                    0x40, 0x01,
//                                                    // Palette
//                                                    0x01, 0x00, 0x00, 0xff, 0x00, 0xff, 0x00,
//                                                    // Pixels
//                                                    0x30, 0x30, 0xc0, 0xc0
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
