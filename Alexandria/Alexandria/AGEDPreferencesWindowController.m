//
//  AGEDPreferencesWindowController.m
//  Alexandria
//
//  Created by Allen Xavier on 8/25/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDPreferencesWindowController.h"

@interface AGEDPreferencesWindowController()

@property (strong, nonatomic) NSMutableArray* fileCollectionsArrayDisplay;
@property (strong, nonatomic) NSMutableArray* fileCollectionTitles;
@property (strong, nonatomic) AGEDFileCollection* selectedFileCollection;
@end

@implementation AGEDPreferencesWindowController

-(instancetype)init
{
	self = [super init];
	if (self) {
		_fileCollectionsArrayDisplay = [NSMutableArray new];
	}
	return self;
}

-(instancetype)initWithFileCollectionsArray:(NSArray *)fileCollectionsArray
{
	self = [self init];
	_fileCollectionsArray = fileCollectionsArray;
	[_fileCollectionsArrayDisplay addObjectsFromArray:fileCollectionsArray];
	AGEDFileCollection* newCollection = [AGEDFileCollection new];
	[newCollection setTitle:@"New File Collection"];
	[_fileCollectionsArrayDisplay addObject:newCollection];
	[self resetFileCollectionTitles];
	return self;
}

#pragma mark NSTableViewDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	// This table view displays the tasks array,     // so the number of entries in the table view will be the same     // as the number of objects in the array
	if ([[tableView identifier] isEqualToString:@"supportedPathExtensionsTable"]){
		return [[_selectedFileCollection supportedPathExtensions] count];
	}
	else if ([[tableView identifier] isEqualToString:@"directoriesTable"]){
		return [[_selectedFileCollection directories] count];
	}
	
	else if ([[tableView identifier] isEqualToString:@"categoryTitlesAndPatternsTable"]){
		return ([[_selectedFileCollection categorySorterRegExPatterns] count] / 2);
	}
	
	return 0;
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	// Return the item from tasks that corresponds to the cell
	// that the table view wants to display
	
	if ([[tableColumn identifier] isEqualToString:@"supportedPathExtensionsColumn"]){
		return [[_selectedFileCollection supportedPathExtensions] objectAtIndex:row];
	}
	else if ([[tableColumn identifier] isEqualToString:@"directoriesColumn"]){
		return [_selectedFileCollection directories][row];
	}
	else if ([[tableColumn identifier] isEqualToString:@"categoryTitleColumn"]){
		return [[_selectedFileCollection categorySorterRegExPatterns] objectAtIndex:(row * 2)];
	}
	else if ([[tableColumn identifier] isEqualToString:@"categoryRegExColumn"]){
		if ([[_selectedFileCollection categorySorterRegExPatterns] count] > 0) {
			return [[_selectedFileCollection categorySorterRegExPatterns] objectAtIndex:((row * 2) + 1)];
		}
	}
	return @(1);
	
}

-(NSArray*)fileCollectionTitles
{
	return _fileCollectionTitles;
}

-(void)setIndexOfSelectedFileCollection:(NSInteger)indexOfSelectedFileCollection
{
	if (indexOfSelectedFileCollection >= 0 && indexOfSelectedFileCollection < [_fileCollectionsArrayDisplay count]) {
		_indexOfSelectedFileCollection = indexOfSelectedFileCollection;
	}
	else{
		_indexOfSelectedFileCollection = 0;
	}
	//mutable copy is used so that changes to the fileCollection are not permanent until it is saved
	_selectedFileCollection = [[_fileCollectionsArrayDisplay objectAtIndex:_indexOfSelectedFileCollection] mutableCopy];
	[_preferencesWindow refreshAllTables];
	[_preferencesWindow setDisplayedFileCollection:_selectedFileCollection];
}

-(void)resetFileCollectionTitles
{
	_fileCollectionTitles = [NSMutableArray new];
	for (AGEDFileCollection* collection in _fileCollectionsArrayDisplay) {
		[_fileCollectionTitles addObject:[collection title]];
	}
}

//add to later to save the file collections to disk
-(void)saveFileCollection:(AGEDFileCollection *)fileCollection
{
	[_fileCollectionsArrayDisplay setObject:fileCollection atIndexedSubscript:_indexOfSelectedFileCollection];
	[self resetFileCollectionTitles];
	[_preferencesWindow changeFileCollectionPopUpButtonTitles:_fileCollectionTitles selectedItemIndex:_indexOfSelectedFileCollection];
	
	//adds a new blank file collection because a new file collection was added
	if (_indexOfSelectedFileCollection == [_fileCollectionsArrayDisplay count] - 1) {
		AGEDFileCollection* newCollection = [AGEDFileCollection new];
		[newCollection setTitle:@"New File Collection"];
		[_fileCollectionsArrayDisplay addObject:newCollection];
	}
}


@end
