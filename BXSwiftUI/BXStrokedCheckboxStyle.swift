//**********************************************************************************************************************
//
//  BXCircularSlider.swift
//	A circular slider for SwiftUI
//  Copyright ©2020 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import SwiftUI


//----------------------------------------------------------------------------------------------------------------------


public struct BXStrokedCheckboxStyle : ToggleStyle
{
	// Environment
	
	@Environment(\.isEnabled) private var isEnabled
	@Environment(\.controlSize) private var controlSize
	@Environment(\.hasMultipleValues) private var hasMultipleValues
	
	// Necessary to make init available outside this module
	
	public init() {}
    
    // Edge length and corner radius of the checkbox depend on environment controlSize
    
	private var edge:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 15.0
			case .small: 		return 12.0
			case .mini: 		return 9.0
			
			@unknown default:	return 15.0
		}
	}

	private var radius:CGFloat
	{
		switch controlSize
		{
			case .regular: 		return 3.0
			case .small: 		return 2.0
			case .mini: 		return 2.0
			
			@unknown default:	return 3.0
		}
	}

	// Draw the checkbox
	
    public func makeBody(configuration: Self.Configuration) -> some View
    {
		let fillColor = configuration.isOn || self.hasMultipleValues ?
			Color.accentColor :
			Color(white:1.0, opacity:0.07)
		
        return HStack
        {
            ZStack()
            {
				// Fill
				
                RoundedRectangle(cornerRadius:radius)
                    .foregroundColor(fillColor)
                    .frame(width:edge, height:edge)

				// Stroke
				
				RoundedRectangle(cornerRadius:radius)
                    .stroke(Color.gray, lineWidth:0.5)
					.frame(width:edge, height:edge)
				
				// Content
				
				if self.hasMultipleValues
				{
					Text("–").bold().offset(x:0.5, y:0)
				}
				else if configuration.isOn
				{
					Text("✓").bold().offset(x:0.5, y:0)
				}
            }
			
			// Label
			
			configuration.label
        }
        
        // Dim when disabled
        
        .opacity(self.isEnabled ? 1.0 : 0.33)
        
        // Event handling
        
		.onTapGesture
		{
			if self.hasMultipleValues
			{
				configuration.$isOn.wrappedValue = true
			}
			else
			{
				configuration.$isOn.wrappedValue.toggle()
			}
		}
    }
}


//----------------------------------------------------------------------------------------------------------------------
