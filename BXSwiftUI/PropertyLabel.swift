//**********************************************************************************************************************
//
//  PropertyLabel.swift
//	PropertyLabels communicate with each other and decide on a common maximum width for localization purposes
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct PropertyLabel : View
{
	var title:String = ""
	var width:CGFloat = 70.0
	
	init(_ title:String, width:CGFloat = 70.0)
	{
		self.title = title
		self.width = width
	}
	
	public var body: some View
	{
		return Text(title)
		
			// Measure the size of the Text and attach a preference (with its width) to the Text
			
			.background( GeometryReader
			{
				Color.clear.preference(
					key:PropertyLabelKey.self,
					value:[PropertyLabelData(width:$0.size.width)])

			})
			
			// Resize the text to the desired width - which will be the maximum width of all PropertyLabels
			
			.frame(minWidth:width, alignment:.leading)
//			.border(Color.red)
	}
}


//----------------------------------------------------------------------------------------------------------------------


/// Metadata to be attached to PropertyLabel views

public struct PropertyLabelData : Equatable
{
    public let width:CGFloat
}


public struct PropertyLabelKey : PreferenceKey
{
	public typealias Value = [PropertyLabelData]

	public static var defaultValue:[PropertyLabelData] = []

    public static func reduce(value:inout [PropertyLabelData], nextValue:()->[PropertyLabelData])
    {
		value.append(contentsOf: nextValue())
    }
}


//----------------------------------------------------------------------------------------------------------------------
