//
//  AGEDFileRenamePanel.m
//  file viewer prototype
//
//  Created by Allen Xavier on 8/8/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDFileRenamePanel.h"


@implementation AGEDFileRenamePanel

- (instancetype)init
{
    self = [super init];
    if (self) {
		[self setFrame:NSRectFromString(@"{54,340,316,199}") display:YES];
		_mainView = [[NSView alloc] initWithFrame:self.frame];
		
		_fileNameTextField = [[NSTextField alloc] initWithFrame:NSRectFromString(@"{34,79,248,22}")];
		NSCell* fileNameTextFieldCell = [_fileNameTextField cell];
		[fileNameTextFieldCell setWraps:NO];
		[fileNameTextFieldCell setScrollable:YES];
		
		[_mainView addSubview:_fileNameTextField];
		
		
		_fullFileNameLabel = [[NSTextField alloc] initWithFrame:NSRectFromString(@"{31,109,254,17}")];
		[_fullFileNameLabel setEditable:NO];
		NSCell* fileNameLabelCell = [_fullFileNameLabel cell];
		[fileNameLabelCell setLineBreakMode:NSLineBreakByTruncatingHead];
		[_fullFileNameLabel setEnabled:NO];
		[_fullFileNameLabel setStringValue:@"/full/filename/label/otherstuff/test/oeuoeuoeueou/euoou.pdf"];
		[_fullFileNameLabel setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
		[_fullFileNameLabel setBordered:NO];
		[_fullFileNameLabel setDrawsBackground:NO];
		[_fullFileNameLabel setAlignment:NSCenterTextAlignment];
		
		[_mainView addSubview:_fullFileNameLabel];
		
		
		_saveButton = [[NSButton alloc] initWithFrame:NSRectFromString(@"{206,28,82,32}")];
		[_saveButton setTitle:@"Save"];
		[_saveButton setBezelStyle:NSRoundedBezelStyle];
		[_saveButton setTarget:self];
		[_saveButton setAction:@selector(saveButtonAction)];
		[[_saveButton cell] setKeyEquivalent:@"\r"];
		[_mainView addSubview:_saveButton];
		
		NSButton* cancelButton = [[NSButton alloc] initWithFrame:NSRectFromString(@"{28,28,82,32}")];
		[cancelButton setTitle:@"Cancel"];
		[cancelButton setBezelStyle:NSRoundedBezelStyle];
		[cancelButton setTarget:self];
		[cancelButton setAction:@selector(cancelOperation:)];
		[_mainView addSubview:cancelButton];
		
		NSSegmentedControl* fileNameFormatterControl = [[NSSegmentedControl alloc] initWithFrame:NSRectFromString(@"{32,141,261,24}")];
		
		
		NSSegmentedCell* cell = [NSSegmentedCell new];
		[cell setSegmentCount:3];
		[cell setTrackingMode:NSSegmentSwitchTrackingMomentary];
		
		[cell setSegmentCount:3];
		[cell setWidth:82 forSegment:0];
		[cell setLabel:@"Capitalize" forSegment:0];
		
		[cell setWidth:82 forSegment:1];
		[cell setLabel:@"Lower Case" forSegment:1];
		
		[cell setWidth:82 forSegment:2];
		[cell setLabel:@"Upper Case" forSegment:2];
		
		[fileNameFormatterControl setCell:cell];
		
		[cell setTarget:self];
		[cell setAction:@selector(fileNameFormatterControlAction:)];
		
		[_mainView addSubview:fileNameFormatterControl];
		
		[self setContentView:_mainView];
		[self setTitle:@"Rename File"];
		[self setIsVisible:YES];
		
		[self selectKeyViewFollowingView:fileNameFormatterControl];
		[self setReleasedWhenClosed:YES];
		[self center];
		[self makeKeyWindow];
		
    }
    return self;
}

-(instancetype)initWithFile:(AGEDFile *)editedFile controller:(id<AGEDTableViewController>)controller
{
	self = [self init];
	if (self) {
		[self setEditedFile:editedFile];
		[self setController:controller];
		[self setIsVisible:YES];
	}
	return self;
}

-(void)capitalizeWord:(id)sender
{
	[_fileNameTextField setStringValue:[[_fileNameTextField stringValue] capitalizedString]];
}
-(void)lowercaseWord:(id)sender
{
	[_fileNameTextField setStringValue:[[_fileNameTextField stringValue] lowercaseString]];
}
-(void)uppercaseWord:(id)sender
{
	[_fileNameTextField setStringValue:[[_fileNameTextField stringValue] uppercaseString]];
}

-(void)fileNameFormatterControlAction:(id)sender
{
	if ([sender selectedSegment] == 0) {
		[self capitalizeWord:sender];
	}
	else if ([sender selectedSegment] == 2){
		[self uppercaseWord:sender];
	}
	else{
		[self lowercaseWord:sender];
	}
}

-(void)cancelOperation:(id)sender{
	[self setIsVisible:NO];
}

-(void)saveButtonAction
{
	_editedFileName = [_fileNameTextField stringValue];
	[_controller renameFilePanelAction:self];
	[self setIsVisible:NO];
}

-(void)setEditedFile:(AGEDFile *)editedFile
{
	_editedFile = editedFile;
	[_fullFileNameLabel setStringValue:[_editedFile fullFileName]];
	[_fileNameTextField setStringValue:[_editedFile title]];
	[self setIsVisible:NO];
}

//-(void)keyUp:(NSEvent *)theEvent
//{
//	int enterButtonKeyCode = 36;
//	if ([theEvent keyCode] == enterButtonKeyCode) {
////		[self saveButtonAction];
////		[_saveButton accessibilityPerformAction:NSAccessibilityPressAction];
//		
//	}
//}

@end
