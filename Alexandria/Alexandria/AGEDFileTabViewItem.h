//
//  AGEDFileTabViewItem.h
//  Alexandria
//
//  Created by Allen Xavier on 7/28/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AGEDTableViewController.h"

@interface AGEDFileTabViewItem : NSTabViewItem

-(void)setDataSourceForTableView:(id<NSTableViewDataSource>)tableViewDataSource;

-(void)updateTableView;

-(NSInteger)selectedRow;

//-(AGEDTableViewController*)tableViewController;

@end
