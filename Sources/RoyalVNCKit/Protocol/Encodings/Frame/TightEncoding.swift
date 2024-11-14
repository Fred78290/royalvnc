#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension VNCProtocol {
    struct TightEncoding: VNCFrameEncoding {
        let encodingType = VNCFrameEncodingType.tight.rawValue
        let maxRectangleWidth = 2048 // NOTE: To reduce implementation complexity, the width of any Tight-encoded rectangle cannot exceed 2048 pixels.
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
        
        let shouldResetZlibStream0 = compressionControlBits[0] == .one
        let shouldResetZlibStream1 = compressionControlBits[1] == .one
        let shouldResetZlibStream2 = compressionControlBits[2] == .one
        let shouldResetZlibStream3 = compressionControlBits[3] == .one
        
        // TODO: Reset Zlib streams as appropriate
        
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
        
        // TODO: Get TPIXEL format, check if less than 12 bytes are required
        
        let fbProps = framebuffer.sourceProperties
        let tPixelProps = tPixelProperties(sourceProperties: fbProps,
                                           framebufferWidth: .init(framebuffer.size.width))
        
        switch compressionMethod {
            case .fill:
                // Read a single color value in TPIXEL format
                let bytesPerPixel = tPixelProps.bytesPerPixel
                
                var tPixel = try await connection.read(length: bytesPerPixel)
                
                framebuffer.fill(region: rectangle.region,
                                 withPixel: &tPixel)
            case .basic, .basicWithoutZlib:
                // TODO
                fatalError("Not implemented")
            case .jpeg:
                // TODOa
                fatalError("Not implemented")
        }
        
        // TODO
//        let dataLength = try await connection.read What and only if compression is used?! Which kind of compression?
    }
}

private extension VNCProtocol.TightEncoding {
    enum CompressionMethod {
        case basic
        case basicWithoutZlib
        case fill
        case jpeg
    }
    
    enum FilterID {
        case copy // NOTE: aka no filter
        case palette
        case gradient
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
    
    func tPixelProperties(sourceProperties: VNCFramebuffer.Properties,
                          framebufferWidth: Int) -> VNCFramebuffer.Properties {
        if !sourceProperties.usesColorMap && sourceProperties.bitsPerPixel == 32 && sourceProperties.colorDepth == 24 && sourceProperties.alphaMax == 0
            && sourceProperties.redMax == 255 && sourceProperties.greenMax == 255 && sourceProperties.blueMax == 255 {
            // Received as R,G,B --> memory(LE): RGB0 (0x0BGR)
            return .init(pixelFormat: .init(bitsPerPixel: 24, depth: 24, bigEndian: false, trueColor: true, redMax: 255, greenMax: 255, blueMax: 255, redShift: 0, greenShift: 8, blueShift: 16),
                         width: framebufferWidth)
        }
        
        return sourceProperties
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
