#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public struct VNCScreenDesktop {
	public var screenID: UInt32 = 0
	public var posX: UInt16 = 0
	public var posY: UInt16 = 0
	public var width: UInt16 = 0
	public var height: UInt16 = 0
	public var flags: UInt32 = 0
}

extension VNCProtocol {
	struct SetDesktopSize: VNCSendableMessage {
		let messageType: UInt8 = 251
		let desktopSizes: [VNCScreenDesktop]
	}
}

extension VNCProtocol.SetDesktopSize {
	var data: Data {
		let length = 8 + (MemoryLayout<VNCScreenDesktop>.size * desktopSizes.count)

		var data = Data(capacity: length)

		// Message type
		data.append(messageType)
		data.appendPadding(length: 1)

		var bounds: NSRect = .zero

		self.desktopSizes.forEach { desktopSize in
			let desktopRect = NSRect(x: CGFloat(desktopSize.posX), y: CGFloat(desktopSize.posY), width: CGFloat(desktopSize.width), height: CGFloat(desktopSize.height))

			bounds = NSUnionRect(bounds, desktopRect)
		}

		data.append(UInt16(bounds.size.width), bigEndian: true)
		data.append(UInt16(bounds.size.height), bigEndian: true)
		data.append(UInt8(desktopSizes.count))
		data.appendPadding(length: 1)

		self.desktopSizes.forEach { desktopSize in
			data.append(desktopSize.screenID, bigEndian: true)
			data.append(desktopSize.posX, bigEndian: true)
			data.append(desktopSize.posY, bigEndian: true)
			data.append(desktopSize.width, bigEndian: true)
			data.append(desktopSize.height, bigEndian: true)
			data.append(desktopSize.flags, bigEndian: true)
		}

		guard data.count == length else {
			fatalError("VNCProtocol.SetDesktopSize data.count (\(data.count)) != \(length)")
		}

		return data
	}

	func send(connection: NetworkConnectionWriting) async throws {
		try await connection.write(data: data)
	}
}
