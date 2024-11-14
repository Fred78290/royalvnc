#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public enum VNCPseudoEncodingType: VNCEncodingType {
	case lastRect = -224
	case cursor = -239
	case desktopName = -307
	case continuousUpdates = -313
	case desktopSize = -223
	case extendedDesktopSize = -308
	
	// Level 1 means lowest compression level, Level 10 means highest compression level
	
	/// Lowest compression level
	case compressionLevel1 = -256
	case compressionLevel2 = -255
	case compressionLevel3 = -254
	case compressionLevel4 = -253
	case compressionLevel5 = -252
	case compressionLevel6 = -251
	case compressionLevel7 = -250
	case compressionLevel8 = -249
	case compressionLevel9 = -248
	/// Highest compression level
	case compressionLevel10 = -247
    
    // Level 1 means lowest JPEG quality, Level 10 means highest JPEG quality
    
    /// Lowest JPEG quality
    case jpegCompressionLevel1 = -32
    case jpegCompressionLevel2 = -31
    case jpegCompressionLevel3 = -30
    case jpegCompressionLevel4 = -29
    case jpegCompressionLevel5 = -28
    case jpegCompressionLevel6 = -27
    case jpegCompressionLevel7 = -26
    case jpegCompressionLevel8 = -25
    case jpegCompressionLevel9 = -24
    /// Highest JPEG quality
    case jpegCompressionLevel10 = -23
	
	case extendedClipboard = 0xc0a1e5ce
}

extension VNCPseudoEncodingType: CustomStringConvertible {
	public var description: String {
		switch self {
			case .lastRect:
				"Last Rectangle"
			case .cursor:
				"Cursor"
			case .desktopName:
				"Desktop Name"
			case .continuousUpdates:
				"Continuous Updates"
			case .desktopSize:
				"Desktop Size"
			case .extendedDesktopSize:
				"Extended Desktop Size"
                
			case .compressionLevel1:
				"Compression Level 1"
			case .compressionLevel2:
				"Compression Level 2"
			case .compressionLevel3:
				"Compression Level 3"
			case .compressionLevel4:
				"Compression Level 4"
			case .compressionLevel5:
				"Compression Level 5"
			case .compressionLevel6:
				"Compression Level 6"
			case .compressionLevel7:
				"Compression Level 7"
			case .compressionLevel8:
				"Compression Level 8"
			case .compressionLevel9:
				"Compression Level 9"
			case .compressionLevel10:
				"Compression Level 10"
                
            case .jpegCompressionLevel1:
                "JPEG Compression Level 1"
            case .jpegCompressionLevel2:
                "JPEG Compression Level 2"
            case .jpegCompressionLevel3:
                "JPEG Compression Level 3"
            case .jpegCompressionLevel4:
                "JPEG Compression Level 4"
            case .jpegCompressionLevel5:
                "JPEG Compression Level 5"
            case .jpegCompressionLevel6:
                "JPEG Compression Level 6"
            case .jpegCompressionLevel7:
                "JPEG Compression Level 7"
            case .jpegCompressionLevel8:
                "JPEG Compression Level 8"
            case .jpegCompressionLevel9:
                "JPEG Compression Level 9"
            case .jpegCompressionLevel10:
                "JPEG Compression Level 10"
                
			case .extendedClipboard:
				"Extended Clipboard"
		}
	}
}
