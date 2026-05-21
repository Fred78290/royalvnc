//
//  VNCConnection+SetDesktopSize.swift
//  RoyalVNCKit
//
//  Created by Frederic BOLTZ on 21/05/2026.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

extension VNCConnection {
	public func enqueueDesktopSize(_ desktops: [VNCScreenDesktop]) {
		let message = VNCProtocol.SetDesktopSize(desktopSizes: desktops)
		enqueueClientToServerMessage(message)
	}

	public func setDesktopSize(_ size: CGSize) {
		let desktop = VNCScreenDesktop(width: UInt16(size.width), height: UInt16(size.height))
		
		self.enqueueDesktopSize([desktop])
	}
}
