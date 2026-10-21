//**********************************************************************************************************************
//
//  BXMultiValueNativeSlider-Tests.swift
//	Tests the undo behavior of the native multi value slider
//  Copyright ©2026 Peter Baumgartner. All rights reserved.
//
//**********************************************************************************************************************


import Testing
import AppKit
@testable import BXSwiftUI


//----------------------------------------------------------------------------------------------------------------------


@Suite("BXMultiValueNativeSlider")

@MainActor struct BXMultiValueNativeSliderTests
{
	final class Target
	{
		var value = 0
	}


	/// Simulates one drag of the slider with 5 changes and returns how many undo steps it takes to revert it all.
	/// The slider's action runs the run loop in default mode for every change (DispatchQueue.main.executeScheduledBlocks).

	static func undoSteps(afterDragWith undoManager:UndoManager, registeringBeforeDrag:Bool = false) -> (Int,Target)
	{
		let cell = NSMultiValueSliderCell()
		cell.undoManager = undoManager
		let slider = NSSlider()
		slider.cell = cell
		let target = Target()

		// Something registered in the same event before the drag, so an automatic undo group is already open

		if registeringBeforeDrag
		{
			undoManager.registerUndo(withTarget:target) { $0.value = 0 }
		}

		_ = cell.startTracking(at:.zero, in:slider)

		for i in 1...5
		{
			undoManager.registerUndo(withTarget:target) { $0.value = i-1 }
			target.value = i
			_ = RunLoop.main.limitDate(forMode:.default)		// what the slider's action does for each change
		}

		cell.stopTracking(last:.zero, current:.zero, in:slider, mouseIsUp:true)
		RunLoop.main.run(mode:.default, before:Date(timeIntervalSinceNow:0.1))		// the end of the event

		var steps = 0

		while undoManager.canUndo && steps < 10
		{
			undoManager.undo()
			steps += 1
		}

		return (steps,target)
	}


	/// The default mode run loop pass closes AppKit's automatic undo group of the current event, so every step of a drag
	/// became an undo step of its own. The cell groups a drag explicitly, and switches the automatic grouping back on.

	@Test("A drag of the slider is a single undo step")

	func testDragIsSingleUndoStep()
	{
		let undoManager = UndoManager()
		let (steps,target) = Self.undoSteps(afterDragWith:undoManager)

		#expect(steps == 1)
		#expect(target.value == 0)
		#expect(undoManager.groupsByEvent)
		#expect(undoManager.groupingLevel == 0)
	}


	/// If an automatic group is already open when the drag starts, the drag ends up inside it, and the group is still
	/// closed at the end of the event - nothing stays open.

	@Test("A drag inside an already open undo group is still a single undo step")

	func testDragInsideOpenGroup()
	{
		let undoManager = UndoManager()
		let (steps,target) = Self.undoSteps(afterDragWith:undoManager, registeringBeforeDrag:true)

		#expect(steps == 1)
		#expect(target.value == 0)
		#expect(undoManager.groupsByEvent)
		#expect(undoManager.groupingLevel == 0)
	}
}


//----------------------------------------------------------------------------------------------------------------------
