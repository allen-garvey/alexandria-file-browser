//
//  AGEDFileTabViewItem2.h
//  Alexandria
//
//  Created by Allen Xavier on 7/28/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AGEDFileTabViewItem2 : NSTabViewItem

@property (strong, nonatomic) AGEDTableView* mainTableView;

-(void)setDataSourceForTableView:(id<NSTableViewDataSource>)tableViewDataSource;

-(void)updateTableView;

-(NSInteger)selectedRow;

-(NSArray*)mainTableSortDescriptors;

-(void)setMainTableSortDescriptors:(NSArray*)descriptors;


@end
