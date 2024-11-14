#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import XCTest

@testable import RoyalVNCKit

class ZRLEEncodingTest: XCTestCase {
    let encoding = VNCProtocol.ZRLEEncoding(zStream: .init())
    
    func createSetup() throws -> EncodingTestSetup {
        try .init(encoding: encoding,
                  colorDepth: .depth24Bit,
                  framebufferSize: .init(width: 4, height: 4))
    }
    
    func testZRLERawSubEncoding() async throws {
        let setup = try createSetup()
        
        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
                                                  encodingType: setup.encodingType,
                                                  data: [
                                                    0x00, 0x00, 0x00, 0x0e, 0x78, 0x5e,
                                                    0x62, 0x60, 0x60, 0xf8, 0x4f, 0x12,
                                                    0x02, 0x00, 0x00, 0x00, 0xff, 0xff
                                                  ])
        
        let connection = data.connection
        
        try await encoding.decodeRectangle(data.rectangle,
                                           framebuffer: setup.framebuffer,
                                           connection: connection,
                                           logger: setup.logger)
        
        let expectedData = Data([
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    func testZRLESolidSubEncoding() async throws {
        let setup = try createSetup()
        
        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
                                                  encodingType: setup.encodingType,
                                                  data: [
                                                    0x00, 0x00, 0x00, 0x0c, 0x78, 0x5e,
                                                    0x62, 0x64, 0x60, 0xf8, 0x0f, 0x00,
                                                    0x00, 0x00, 0xff, 0xff
                                                  ])
        
        let connection = data.connection
        
        try await encoding.decodeRectangle(data.rectangle,
                                           framebuffer: setup.framebuffer,
                                           connection: connection,
                                           logger: setup.logger)
        
        let expectedData = Data([
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    func testZRLEPaletteTileSubEncoding() async throws {
        let setup = try createSetup()
        
        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
                                                  encodingType: setup.encodingType,
                                                  data: [
                                                    0x00, 0x00, 0x00, 0x12, 0x78, 0x5E,
                                                    0x62, 0x62, 0x60,  248, 0xff, 0x9F,
                                                    0x01, 0x08, 0x3E, 0x7C, 0x00, 0x00,
                                                    0x00, 0x00, 0xff, 0xff
                                                  ])
        
        let connection = data.connection
        
        try await encoding.decodeRectangle(data.rectangle,
                                           framebuffer: setup.framebuffer,
                                           connection: connection,
                                           logger: setup.logger)
        
        let expectedData = Data([
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff,
            0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    func testZRLERLETileSubEncoding() async throws {
        let setup = try createSetup()
        
        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
                                                  encodingType: setup.encodingType,
                                                  data: [
                                                    0x00, 0x00, 0x00, 0x0d, 0x78, 0x5e,
                                                    0x6a, 0x60, 0x60, 0xf8, 0x2f, 0x00,
                                                    0x00, 0x00, 0x00, 0xff, 0xff
                                                  ])
        
        let connection = data.connection
        
        try await encoding.decodeRectangle(data.rectangle,
                                           framebuffer: setup.framebuffer,
                                           connection: connection,
                                           logger: setup.logger)
        
        let expectedData = Data([
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    func testZRLERLEPaletteTileSubEncoding() async throws {
        let setup = try createSetup()
        
        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
                                                  encodingType: setup.encodingType,
                                                  data: [
                                                    0x00, 0x00, 0x00, 0x11, 0x78, 0x5e,
                                                    0x6a, 0x62, 0x60, 0xf8, 0xff, 0x9f,
                                                    0x81, 0xa1, 0x81, 0x1f, 0x00, 0x00,
                                                    0x00, 0xff, 0xff
                                                  ])
        
        let connection = data.connection
        
        try await encoding.decodeRectangle(data.rectangle,
                                           framebuffer: setup.framebuffer,
                                           connection: connection,
                                           logger: setup.logger)
        
        let expectedData = Data([
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
            0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff, 0x00, 0x00, 0xff, 0xff
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
    
    func testZRLEFailureOnInvalidSubEncoding() async throws {
        let setup = try createSetup()
        
        let data = FrameEncodingRectangleTestData(x: 0, y: 0, width: 4, height: 4,
                                                  encodingType: setup.encodingType,
                                                  data: [
                                                    0x00, 0x00, 0x00, 0x0c, 0x78, 0x5e, 0x6a, 0x64, 0x60, 0xf8, 0x0f, 0x00, 0x00, 0x00, 0xff, 0xff
                                                  ])
        
        let connection = data.connection
        
        do {
            try await encoding.decodeRectangle(data.rectangle,
                                               framebuffer: setup.framebuffer,
                                               connection: connection,
                                               logger: setup.logger)
            
            XCTFail("Expected error but got none")
        } catch {
            guard let vncError = error as? VNCError,
                  case let .protocol(protError) = vncError,
                  case let .zrleInvalidSubencoding(subencoding) = protError else {
                XCTFail("Error should be VNCError.ProtocolError.zrleInvalidSubencoding but is \(error)")
                
                return
            }
            
            XCTAssertEqual(subencoding, 129)
        }
    }
}
