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
        data[cursor..<cursor + maximumLength]
    }
}
