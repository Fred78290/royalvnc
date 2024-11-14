#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import XCTest

@testable import RoyalVNCKit

class CopyRectEncodingTest: XCTestCase {
    let encoding = VNCProtocol.CopyRectEncoding()
    
    func createSetup() throws -> EncodingTestSetup {
        try .init(encoding: encoding,
                  colorDepth: .depth24Bit,
                  framebufferSize: .init(width: 4, height: 4))
    }
    
    func testCopyRectEncoding() async throws {
        let setup = try createSetup()
        
        // Seed some initial data
        let initialDatas: [FrameEncodingRectangleTestData] = [
            .init(x: 0, y: 0, width: 4, height: 4, encodingType: 0, data: [
                0x11, 0x22, 0x33, 255
            ]),
            
            .init(x: 0, y: 0, width: 2, height: 2, encodingType: 0, data: [
                0x00, 0x00, 0xff, 255
            ]),
            
            .init(x: 2, y: 0, width: 2, height: 2, encodingType: 0, data: [
                0x00, 0xff, 0x00, 255
            ]),
        ]
        
        for initialData in initialDatas {
            let region = initialData.rectangle.region
            var data = initialData.data
            
            setup.framebuffer.fill(region: region,
                                   withPixel: &data,
                                   dataFormat: .normal)
        }
        
        let datas: [FrameEncodingRectangleTestData] = [
            .init(x: 0, y: 2, width: 2, height: 2,
                  encodingType: setup.encodingType, data: [
                0x00, 0x02, 0x00, 0x00
            ]),
            
            .init(x: 2, y: 2, width: 2, height: 2,
                  encodingType: setup.encodingType, data: [
                0x00, 0x00, 0x00, 0x00
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
            0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255, 0x00, 0xff, 0x00, 255, 0x00, 0xff, 0x00, 255,
            0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255, 0x00, 0xff, 0x00, 255, 0x00, 0xff, 0x00, 255,
            0x00, 0xff, 0x00, 255, 0x00, 0xff, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255,
            0x00, 0xff, 0x00, 255, 0x00, 0xff, 0x00, 255, 0x00, 0x00, 0xff, 255, 0x00, 0x00, 0xff, 255
        ])
        
        let actualData = setup.framebuffer.data
        
        XCTAssertEqual(expectedData, actualData)
    }
}
