#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import RoyalVNCKit

class ReadableMockConnection: NetworkConnectionReading {
    let data: Data
    var cursor = 0
    
    init(data: Data) {
        self.data = data
    }
    
    func read(minimumLength: Int,
              maximumLength: Int) async throws -> Data {
        defer {
            cursor += maximumLength
        }
        
        let subData = data[cursor..<cursor + maximumLength]
        
        return subData
    }
}
