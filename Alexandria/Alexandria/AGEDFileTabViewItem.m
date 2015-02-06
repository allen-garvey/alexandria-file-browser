//
//  AGEDFileTabViewItem.m
//  Alexandria
//
//  Created by Allen Xavier on 7/28/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDFileTabViewItem.h"

@interface AGEDFileTabViewItem()
@property (strong, nonatomic) NSScrollView* tableContainer;
@property (strong, nonatomic) NSTableView* mainTableView;
@property (strong, nonatomic) AGEDTableViewController* tableViewController;

@end

@implementation AGEDFileTabViewItem

-(id)init
{
	self = [super init];
	
	if (self) {
		NSView* tabView = [self view];
		_tableContainer = [[NSScrollView alloc] initWithFrame:tabView.bounds];
		[_tableContainer setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
		_mainTableView = [[NSTableView alloc] initWithFrame:_tableContainer.frame];
		[_mainTableView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
		
		NSArray* tableColumnsArray = @[@"filename", @"category", @"directory", @"extension", @"date Created", @"file Size"];
		NSDictionary* columnWidths = @{@"filenameColumn" : @(462), @"categoryColumn" : @(152), @"directoryColumn" : @(449), @"extensionColumn" : @(70), @"dateCreatedColumn" : @(169), @"fileSizeColumn" : @(70)};
		//		NSDictionary* columnDescriptors = @{@"categoryColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]], @"filenameColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]], @"directoryColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"directory" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]], @"dateCreatedColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]], @"fileSizeColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"fileCreationDate" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]]};
		NSArray* tableColumnSortKeys = @[@"filename", @"category", @"directory", @"extension", @"fileCreationDate", @"fileSize"];
		
		//		add sorting to columns
		
		int counter = 0;
		for (NSString* columnName in tableColumnsArray) {
			NSString* columnId = [NSString stringWithFormat:@"%@%@", [AGEDAlexandriaUtil trimWhiteSpace:columnName], @"Column"];
			NSTableColumn* tableColumn = [[NSTableColumn alloc] initWithIdentifier:columnId];
			[tableColumn.headerCell setTitle:[columnName capitalizedString]];
			int columnWidth = [columnWidths[columnId] intValue];
			[tableColumn setWidth:columnWidth];
			NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:tableColumnSortKeys[counter] ascending:YES selector:NSSelectorFromString(@"compare:")];
			
			[tableColumn setSortDescriptorPrototype: descriptor];
			[_mainTableView addTableColumn:tableColumn];
			counter++;
		}
		
		//		NSString* columnId = @"filenameColumn";
		//		NSTableColumn* tableColumn = [[NSTableColumn alloc] initWithIdentifier:columnId];
		//		[tableColumn.headerCell setTitle:@"Filename"];
		//		[_mainTableView addTableColumn:tableColumn];
		//
		//		NSString* columnId2 = @"categoryColumn";
		//		NSTableColumn* tableColumn2 = [[NSTableColumn alloc] initWithIdentifier:columnId2];
		//		[tableColumn2.headerCell setTitle:@"Category"];
		//		[_mainTableView addTableColumn:tableColumn2];
		//
		//		NSString* columnId3 = @"directoryColumn";
		//		NSTableColumn* tableColumn3 = [[NSTableColumn alloc] initWithIdentifier:columnId3];
		//		[tableColumn3.headerCell setTitle:@"Directory"];
		//		[_mainTableView addTableColumn:tableColumn3];
		
		
		[_tableContainer setDocumentView:_mainTableView];
		[tabView addSubview:_tableContainer];
		[_tableContainer setHasHorizontalScroller:YES];
		[_tableContainer setHasVerticalScroller:YES];
		[_mainTableView setUsesAlternatingRowBackgroundColors:YES];
		
	}
	
	return self;
}

-(void)setDataSourceForTableView:(id<NSTableViewDataSource>)tableViewDataSource
{
	_tableViewController = tableViewDataSource;
	[_mainTableView setDataSource:tableViewDataSource];
	//	[_mainTableView setDataSource:[AGEDDocument new]];
}

-(void)updateTableView
{
	[_mainTableView reloadData];
}

-(NSInteger)selectedRow
{
	return [_mainTableView selectedRow];
}

-(AGEDTableViewController*)tableViewController
{
	return _tableViewController;
}

@end
