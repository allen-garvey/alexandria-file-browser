//
//  AGEDFileTabViewItem2.m
//  Alexandria
//
//  Created by Allen Xavier on 7/28/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDFileTabViewItem2.h"

@interface AGEDFileTabViewItem2()
@property (strong, nonatomic) NSScrollView* tableContainer;
@property (strong, nonatomic) AGEDTableViewController* tableViewController;

@end

@implementation AGEDFileTabViewItem2

-(id)init
{
	self = [super init];
	
	if (self) {
		NSView* tabView = [self view];
		_tableContainer = [[NSScrollView alloc] initWithFrame:tabView.bounds];
		[_tableContainer setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
		_mainTableView = [[AGEDTableView alloc] initWithFrame:_tableContainer.frame];
//		[_mainTableView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
		
		
		
//		NSArray* tableColumnsArray = @[@"filename", @"category", @"directory", @"date Created", @"file Size"];
//		NSDictionary* columnWidths = @{@"filenameColumn" : @(462), @"categoryColumn" : @(152), @"directoryColumn" : @(449), @"dateCreatedColumn" : @(169), @"fileSizeColumn" : @(70)};
		//		NSDictionary* columnDescriptors = @{@"categoryColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]], @"filenameColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]], @"directoryColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"directory" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]], @"dateCreatedColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]], @"fileSizeColumn" : @[[NSSortDescriptor sortDescriptorWithKey:@"fileCreationDate" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]]};
//		NSArray* tableColumnSortKeys = @[@"filename", @"category", @"directory", @"fileCreationDate", @"fileSize"];
		
		/*
		
		int counter = 0;
		for (NSString* columnName in tableColumnsArray) {
			NSString* columnId = [NSString stringWithFormat:@"%@%@", [AGEDAlexandriaUtil trimWhiteSpace:columnName], @"Column"];
			NSTableColumn* tableColumn = [[NSTableColumn alloc] initWithIdentifier:columnId];
			[tableColumn.headerCell setTitle:[columnName capitalizedString]];
			int columnWidth = [columnWidths[columnId] intValue];
			[tableColumn setWidth:columnWidth];
			int columnMinWidth;
			if (columnWidth > 150) {
				columnMinWidth = columnWidth / 2;
			}
			else{
				columnMinWidth = columnWidth;
			}
			
			[tableColumn setMinWidth:columnMinWidth];

			[tableColumn setEditable:NO];
			
			NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:tableColumnSortKeys[counter] ascending:YES selector:@selector(compare:)];
			
			[tableColumn setSortDescriptorPrototype: descriptor];
			[_mainTableView addTableColumn:tableColumn];
			counter++;
		}
		
		*/
		NSArray* tableColumnsInfoDicts = @[
										   @{@"column name": @"filename", @"column width": @(462), @"column sort desciptor": [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]},
										   @{@"column name": @"category", @"column width": @(152), @"column sort desciptor": [NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]},
										   @{@"column name": @"directory", @"column width": @(449), @"column sort desciptor": [NSSortDescriptor sortDescriptorWithKey:@"directory" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]},
										   @{@"column name": @"date Created", @"column width": @(169), @"column sort desciptor": [NSSortDescriptor sortDescriptorWithKey:@"fileCreationDate" ascending:NO selector:@selector(compare:)]},
										   @{@"column name": @"file Size", @"column width": @(70), @"column sort desciptor": [NSSortDescriptor sortDescriptorWithKey:@"fileSize" ascending:NO selector:@selector(compare:)]}
										   ];
		
		for(NSDictionary* columnInfo in tableColumnsInfoDicts){
			NSString* columnId = [NSString stringWithFormat:@"%@%@", [AGEDAlexandriaUtil trimWhiteSpace:columnInfo[@"column name"]], @"Column"];
			NSTableColumn* tableColumn = [[NSTableColumn alloc] initWithIdentifier:columnId];
			[tableColumn.headerCell setTitle:[columnInfo[@"column name"] capitalizedString]];
			int columnWidth = [columnInfo[@"column width"] intValue];
			[tableColumn setWidth:columnWidth];
			int columnMinWidth;
			if (columnWidth > 150) {
				columnMinWidth = columnWidth / 2;
			}
			else{
				columnMinWidth = columnWidth;
			}
			
			[tableColumn setMinWidth:columnMinWidth];
			
			[tableColumn setEditable:NO];
			
			[tableColumn setSortDescriptorPrototype: columnInfo[@"column sort desciptor"]];
			[_mainTableView addTableColumn:tableColumn];
		}
		
		[_tableContainer setDocumentView:_mainTableView];
		[tabView addSubview:_tableContainer];
		[_tableContainer setHasHorizontalScroller:YES];
		[_tableContainer setHasVerticalScroller:YES];
//		[_mainTableView setUsesAlternatingRowBackgroundColors:YES];
//		[_mainTableView setAllowsMultipleSelection:YES];
		
	}
	
	return self;
}

-(void)setDataSourceForTableView:(id<NSTableViewDataSource>)tableViewDataSource
{
	_tableViewController = tableViewDataSource;
	[_mainTableView setDataSource:tableViewDataSource];
	[_mainTableView setController:tableViewDataSource];
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


-(NSArray*)mainTableSortDescriptors
{
	return [_mainTableView sortDescriptors];
}

-(void)setMainTableSortDescriptors:(NSArray *)descriptors
{
	[_mainTableView setSortDescriptors:descriptors];
}



@end
