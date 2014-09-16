//
//  AGEDTableView.h
//  Alexandria
//
//  Created by Allen Xavier on 8/6/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "AGEDTableViewController.h"
#import "AGEDFileRenamePanel.h"

@protocol AGEDTableViewController;


@interface AGEDTableView : NSTableView

//@property (weak, nonatomic) AGEDTableViewController* controller;

//have to use id because importing "AGEDTableViewController.h" breaks the build
@property (weak, nonatomic) id<AGEDTableViewController> controller;

@end

@protocol AGEDTableViewController <NSObject>

-(void)tableViewRightClickAction:(NSEvent*)theEvent;
-(void)renameFilePanelAction:(AGEDFileRenamePanel*)sender;

@end
