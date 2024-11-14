#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import RoyalVNCKit

struct FrameEncodingRectangleTestData {
    let rectangle: VNCProtocol.Rectangle
    let encodingType: VNCEncodingType
    let data: Data
    
    init(x: UInt16, y: UInt16,
         width: UInt16, height: UInt16,
         encodingType: VNCEncodingType,
         data: [UInt8]) {
        let rawEncodingType = encodingType.int32Value!

        self.encodingType = encodingType
        
        self.rectangle = .init(xPosition: x, yPosition: y,
                               width: width, height: height,
                               encodingType: rawEncodingType)
        
        self.data = .init(data)
    }
}

extension FrameEncodingRectangleTestData {
    var connection: NetworkConnectionReading {
        let mockConnection = ReadableMockConnection(data: data)
        
        return mockConnection
    }
}


extension [FrameEncodingRectangleTestData] {
    var connection: NetworkConnectionReading {
        let dataMerged = reduce(into: Data()) {
            $0.self += $1.data
        }
        
        let mockConnection = ReadableMockConnection(data: dataMerged)
        
        return mockConnection
    }
}
