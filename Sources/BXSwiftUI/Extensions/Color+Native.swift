//**********************************************************************************************************************
//
//  Color+Native.swift
//	Converts a SwiftUI Color to a native NSColor
//  Copyright ©2022 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


#if os(macOS)

import SwiftUI
import AppKit


//----------------------------------------------------------------------------------------------------------------------


public extension NSColor
{
	/// Returns a SwiftUI Color for this NSColor
	
	var color:Color
	{
		let sRGB = self.usingColorSpace(.sRGB) ?? self
		let r:CGFloat = sRGB.redComponent
		let g:CGFloat = sRGB.greenComponent
		let b:CGFloat = sRGB.blueComponent
        return Color(red:r, green:g, blue:b)
	}
}


//----------------------------------------------------------------------------------------------------------------------

#endif
