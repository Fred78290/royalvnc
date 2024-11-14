#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension VNCProtocol {
    class TightEncoding: VNCFrameEncoding {
        let encodingType = VNCFrameEncodingType.tight.rawValue
        let maxRectangleWidth = 2048 // NOTE: To reduce implementation complexity, the width of any Tight-encoded rectangle cannot exceed 2048 pixels.
        
        var zlibStreams: [ZlibStream] = .init(repeating: .init(), count: 4)
    }
}

extension VNCProtocol.TightEncoding {
    func decodeRectangle(_ rectangle: VNCProtocol.Rectangle,
                         framebuffer: VNCFramebuffer,
                         connection: NetworkConnectionReading,
                         logger: VNCLogger) async throws {
        guard rectangle.width <= maxRectangleWidth else {
            // TODO: Convert to error
            fatalError("Tight-encoded rectangle width must be less than or equal to \(maxRectangleWidth) pixels.")
        }
        
        let compressionControlByte = try await connection.readUInt8()
        let compressionControlBits = bits(fromByte: compressionControlByte)
        
        let zlibStreamsIndexesToReset: [Bool] = [
            compressionControlBits[0] == .one,
            compressionControlBits[1] == .one,
            compressionControlBits[2] == .one,
            compressionControlBits[3] == .one
        ]
        
        // Reset Zlib streams as appropriate
        for (idx, shouldReset) in zlibStreamsIndexesToReset.enumerated() {
            guard shouldReset else { continue }
            
            logger.logDebug("Tight resetting Zlib Stream: \(idx)")
            
            zlibStreams[idx] = .init()
        }
        
        let compressionMethod: CompressionMethod
        let readFilter: Bool
        
        if compressionControlBits[7] == .zero {
            compressionMethod = .basic
            readFilter = compressionControlBits[6] == .one
        } else {
            let mostSignificantBits = (compressionControlByte >> 4) & 0x0F
            
            switch mostSignificantBits {
            case 0b1000:
                compressionMethod = .fill
                readFilter = false
            case 0b1001:
                compressionMethod = .jpeg
                readFilter = false
            case 0b1010:
                compressionMethod = .basicWithoutZlib
                readFilter = false
            case 0b1110:
                compressionMethod = .basicWithoutZlib
                readFilter = true
            default:
                // TODO: Convert to error
                fatalError("Invalid compression method")
            }
        }
        
        logger.logDebug("Tight Compression Method: \(compressionMethod.description)")
        
        let filterID: FilterID
        
        if readFilter {
            let filterIDByte = try await connection.readUInt8()
            
            switch filterIDByte {
            case 0:
                filterID = .copy
            case 1:
                filterID = .palette
            case 2:
                filterID = .gradient
            default:
                // TODO: Convert to error
                fatalError("Invalid filter ID: \(filterIDByte)")
            }
        } else {
            filterID = .copy
        }
        
        logger.logDebug("Tight Filter ID: \(filterID.description)")
        
        // TODO: Get TPIXEL format, check if less than 12 bytes are required
        
        let sourceProperties = framebuffer.sourceProperties
        let sourcePropertiesTight = sourceProperties.tightProperties(framebufferWidth: framebuffer.size.width)
        
        switch compressionMethod {
            case .fill:
                // Read a single color value in TPIXEL format
                let bytesPerPixel = sourcePropertiesTight.bytesPerPixel
                
                var tPixel = try await connection.read(length: bytesPerPixel)
                
                framebuffer.fill(region: rectangle.region,
                                 withPixel: &tPixel,
                                 dataFormat: .tight)
            case .basic:
                // TODO
                fatalError("Not implemented")
            case .basicWithoutZlib:
                // TODO
                fatalError("Not implemented")
            case .jpeg:
                // TODO
                fatalError("Not implemented")
        }
        
        // TODO
//        let dataLength = try await connection.read What and only if compression is used?! Which kind of compression?
    }
}

private extension VNCProtocol.TightEncoding {
    enum CompressionMethod: CustomStringConvertible {
        case basic
        case basicWithoutZlib
        case fill
        case jpeg
        
        var description: String {
            switch self {
            case .basic:
                "Basic"
            case .basicWithoutZlib:
                "Basic without Zlib"
            case .fill:
                "Fill"
            case .jpeg:
                "JPEG"
            }
        }
    }
    
    enum FilterID: CustomStringConvertible {
        case copy // NOTE: aka no filter
        case palette
        case gradient
        
        var description: String {
            switch self {
            case .copy:
                "Copy"
            case .palette:
                "Palette"
            case .gradient:
                "Gradient"
            }
        }
    }
    
    enum Bit: UInt8, CustomStringConvertible {
        case zero
        case one

        var description: String {
            switch self {
            case .one:
                "1"
            case .zero:
                "0"
            }
        }
    }
    
    func bits(fromByte byte: UInt8) -> [Bit] {
        var byte = byte
        var bits = [Bit](repeating: .zero, count: 8)
        
        for i in 0..<8 {
            let currentBit = byte & 0x01
            
            if currentBit != 0 {
                bits[i] = .one
            }

            byte >>= 1
        }

        return bits
    }
}
