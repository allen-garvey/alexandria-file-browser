//
//  AGEDTableView.m
//  Alexandria
//
//  Created by Allen Xavier on 8/6/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDTableView.h"

@interface AGEDTableView()



@end

@implementation AGEDTableView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAllowsMultipleSelection:YES];
		[self setUsesAlternatingRowBackgroundColors:YES];
		[self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
		[self registerForDraggedTypes:[NSArray arrayWithObjects:NSFileContentsPboardType, nil]];
		[self setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (void) rightMouseDown: (NSEvent*) theEvent
{
	
	[_controller tableViewRightClickAction:theEvent];
	
}

-(void)keyDown:(NSEvent *)theEvent
{
	AGEDAppDelegate* app = [NSApp delegate];
	int RETURN_KEY_CODE = 36;
	if ([theEvent keyCode] == RETURN_KEY_CODE) {
		[app openFileButtonPressed:self];
	}

	
}







@end
