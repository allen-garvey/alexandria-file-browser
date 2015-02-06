//
//  AGEDTableViewController.m
//  Alexandria
//
//  Created by Allen Xavier on 7/28/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDTableViewController.h"

@interface AGEDTableViewController()

@property (strong, nonatomic) NSMutableArray* fileArray;
@property (strong, nonatomic) NSMutableArray* fileArrayDisplay;
@property (strong, nonatomic) AGEDFileRenamePanel* renameFilePanel;



@end

@implementation AGEDTableViewController


-(void)setFileCollection:(AGEDFileCollection *)fileCollection
{
	_fileCollection = fileCollection;
	_fileArray = [_fileCollection fileArray];
	[_fileArray sortUsingDescriptors:[_fileCollection fileSortDescriptors]];
	_fileArrayDisplay = [_fileArray mutableCopy];
	if ([_fileCollection removeDuplicateFilesBasedOnPathPriority]) {
		self.tableViewState = AGEDNonDuplicateFilesView;
	}
	else{
		self.tableViewState = AGEDAllFilesView;
	}
	
}

-(void)setTabViewItem:(AGEDFileTabViewItem2 *)tabViewItem
{
	_tabViewItem = tabViewItem;
	[_tabViewItem setLabel:[_fileCollection title]];
	[_tabViewItem setDataSourceForTableView:self];
	[[_tabViewItem mainTableView] setTarget:self];
	[[_tabViewItem mainTableView] setDoubleAction:@selector(openSelectedFileInDefaultApp)];
	
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	// This table view displays the tasks array,     // so the number of entries in the table view will be the same     // as the number of objects in the array
	return [_fileArrayDisplay count];
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	// Return the item from tasks that corresponds to the cell
	// that the table view wants to display
	
	AGEDFile *file = [_fileArrayDisplay objectAtIndex:row];
	
	if ([[tableColumn identifier] isEqualToString:@"filenameColumn"]) {
		return [file filename];
	}
	else if ([[tableColumn identifier] isEqualToString:@"categoryColumn"]){
		return [file category];
	}
	else if ([[tableColumn identifier] isEqualToString:@"fileSizeColumn"]){
		return [file fileSizeString];
	}
	else if ([[tableColumn identifier] isEqualToString:@"dateCreatedColumn"]){
		return [file fileCreationDateString];
	}
	else if ([[tableColumn identifier] isEqualToString:@"extensionColumn"]){
		return [file extension];
	}
	else{
		return [file directory];
	}
	
}

-(void)displaySelectedFileInFinder:(NSUInteger)selectedRow
{
	AGEDFile *selectedFile = [_fileArrayDisplay objectAtIndex:selectedRow];
	[selectedFile openInFinder];
	
}

-(void)openSelectedFileInDefaultApp:(NSUInteger)selectedRow
{
	AGEDFile *selectedFile = [_fileArrayDisplay objectAtIndex:selectedRow];
	[selectedFile openInDefaultApplication];
	
}

-(void)openSelectedFileInDefaultApp
{
	NSInteger selectedRow = [[_tabViewItem mainTableView] clickedRow];
	[self openSelectedFileInDefaultApp:selectedRow];
}

-(void)displaySearchResults:(NSString*)searchRegEx
{
	if ([searchRegEx isEqualToString:@""]) {
		_fileArrayDisplay = _fileArray;
	}
	else{
		_fileArrayDisplay = [NSMutableArray new];
		AGEDRegExMatcher* matcher = [[AGEDRegExMatcher alloc] initWithPattern:searchRegEx];
		for (AGEDFile* file in _fileArray) {
			if ([matcher isFileMatchCaseInsensitive:file]) {
				[_fileArrayDisplay addObject:file];
			}
		}
	}
	
	[self updateView];
}

-(void)updateFileCountLabel
{
	[_fileCountLabel setStringValue:[NSString stringWithFormat:@"%lu files %@", [_fileArrayDisplay count], [self totalDisplayedFileSize]]];
}

-(void)updateView
{
	[_tabViewItem updateTableView];
	[self updateFileCountLabel];
}

-(NSString*)totalDisplayedFileSize
{
	NSInteger totalSize = 0;
	for (AGEDFile* file in _fileArrayDisplay) {
		NSDictionary* fileInfo = [file fileInfo];
		NSString* fileSize = fileInfo[@"NSFileSize"];
		totalSize = totalSize + [fileSize integerValue];
	}
	return [NSByteCountFormatter stringFromByteCount:totalSize countStyle:NSByteCountFormatterCountStyleFile];
	
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
	[_fileArrayDisplay sortUsingDescriptors:[_tabViewItem mainTableSortDescriptors]];
	[_tabViewItem updateTableView];
}

-(void)resetTableToDefaults
{
//used when tabs are changed after a search so that all results are displayed when tab is reloaded
	_fileArrayDisplay = _fileArray;
}

-(void)refreshTable
{
//	used to refresh the table results if files are added or deleteted while program is running
	NSArray* currentDescriptor = [[self tabViewItem] mainTableSortDescriptors];
	NSDictionary* fileCollectionSerialized = [_fileCollection serializeToDictionary];
	AGEDFileCollection* refreshedFileCollection = [[AGEDFileCollection alloc] initFromDictionary:fileCollectionSerialized];
	[self setFileCollection:refreshedFileCollection];
	[[self tabViewItem] setMainTableSortDescriptors:currentDescriptor];
	[_fileArray sortUsingDescriptors:currentDescriptor];
	_fileArrayDisplay = [_fileArray mutableCopy];
	[self updateView];
	
}

-(void)setFileDuplicatesDisplayed:(BOOL)shouldBeDisplayed
{
	[_fileCollection setRemoveDuplicateFilesBasedOnPathPriority:!shouldBeDisplayed];
	[self refreshTable];
}
-(BOOL)fileDuplicatesDisplayed
{
	return ![_fileCollection removeDuplicateFilesBasedOnPathPriority];
}

-(void)showDuplicateFiles
{
	_fileArray = [_fileCollection duplicateFilesArray];
	NSArray *descriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"directory" ascending:YES]];
	[_fileArray sortUsingDescriptors:descriptors];
	_fileArrayDisplay = [_fileArray mutableCopy];
	[self updateView];
}

-(void)setTableViewSortDescriptors:(NSArray *)descriptors
{
	[[self tabViewItem] setMainTableSortDescriptors:descriptors];
}

-(void)setTableViewState:(AGEDTableViewState)tableViewState
{
	if (_tableViewState == tableViewState) {
		return;
	}
	_tableViewState = tableViewState;
	
	switch (_tableViewState) {
		case AGEDDuplicateFilesView:
			[self showDuplicateFiles];
			break;
		case AGEDNonDuplicateFilesView:
			[self setFileDuplicatesDisplayed:NO];
			break;
			
		default:
			[self setFileDuplicatesDisplayed:YES];
			break;
	}
}

-(void)trashSelectedFile:(NSUInteger)selectedRow
{
	NSURL* selectedFileURL = [self selectedFileURL:selectedRow];
	NSFileManager* fm = [NSFileManager defaultManager];
	
	NSError* error;
	
	[fm trashItemAtURL:selectedFileURL resultingItemURL:nil error:&error];
	if (error) {
		NSLog(@"%@", error);
	}
}

#pragma mark - File Selection Utility Methods

-(AGEDFile *)selectedFile:(NSUInteger)selectedRow{
	return [_fileArrayDisplay objectAtIndex:selectedRow];
}

-(NSURL*)selectedFileURL:(NSUInteger)selectedRow
{
	AGEDFile* selectedFile = [self selectedFile:selectedRow];
	return [[NSURL alloc] initFileURLWithPath:[selectedFile fullFileName] isDirectory:NO];
}

#pragma mark file rename panel methods

-(void)tableViewRightClickAction:(NSEvent*)theEvent
{
	NSPoint mousePoint = [[_tabViewItem mainTableView] convertPoint:[theEvent locationInWindow] fromView:nil];
	NSInteger clickedRow = [[_tabViewItem mainTableView] rowAtPoint:mousePoint];
	NSIndexSet* currentRow = [[NSIndexSet alloc] initWithIndex:clickedRow];
	[[_tabViewItem mainTableView] selectRowIndexes:currentRow byExtendingSelection:NO];
//	NSLog(@"right mouse button clicked at row %ld", (long)clickedRow);
	[NSMenu popUpContextMenu:_tableViewRightClickMenu withEvent:theEvent forView:nil];
}

-(void)renameFile:(AGEDFile*)file fileNameFormattingBlock:(NSString* (^)(NSString *fileName))fileNameFormattingBlock
{
	NSString* fileName = [file filename];
	NSString* formattedFileName = fileNameFormattingBlock(fileName);
	//prevents unnecessary file renames
	if ([fileName isEqualToString:formattedFileName]) {
		return;
	}
	
	NSFileManager* fm = [NSFileManager defaultManager];
	[fm changeCurrentDirectoryPath:[file directory]];
	
	NSError* error;
	
	NSDate* now = [NSDate new];
	NSTimeInterval ti =  [now timeIntervalSince1970];
	NSString* salt = @"aoeuxkhuda494";
	NSString* tempFileName = [NSString stringWithFormat:@"%@%ld%@-temp", salt, (long)ti, fileName];
	
	[fm moveItemAtPath: fileName toPath: tempFileName error: &error];
	if (error) {
		NSLog(@"%@", error);
		[NSAlert alertWithError:error];
	}
	NSError* error2;
	
	[fm moveItemAtPath: tempFileName toPath: formattedFileName error: &error2];
	if (error2) {
		NSLog(@"%@", error2);
		[NSAlert alertWithError:error2];
	}
}

-(void)capitalizeFileName:(NSUInteger)selectedRow
{
	AGEDFile* file = [_fileArrayDisplay objectAtIndex:selectedRow];
	
	[self renameFile:file fileNameFormattingBlock:^(NSString* fileName){
		NSString* capitalizedFileName = [[[fileName stringByDeletingPathExtension] capitalizedString] stringByAppendingPathExtension:[fileName pathExtension]];
		return capitalizedFileName;
	}];
		
}

-(void)lowerCaseFileName:(NSUInteger)selectedRow
{
	AGEDFile* file = [_fileArrayDisplay objectAtIndex:selectedRow];
	
	[self renameFile:file fileNameFormattingBlock:^(NSString* fileName){
		NSString* lowercaseFileName = [[[fileName stringByDeletingPathExtension] lowercaseString] stringByAppendingPathExtension:[fileName pathExtension]];
		return lowercaseFileName;
	}];
}

-(void)upperCaseFileName:(NSUInteger)selectedRow
{
	AGEDFile* file = [_fileArrayDisplay objectAtIndex:selectedRow];
	
	[self renameFile:file fileNameFormattingBlock:^(NSString* fileName){
		NSString* uppercaseFileName = [[[fileName stringByDeletingPathExtension] uppercaseString] stringByAppendingPathExtension:[fileName pathExtension]];
		return uppercaseFileName;
	}];
}

-(void)displayRenameFilePanel:(NSUInteger)selectedRow
{
	AGEDFile* file = [_fileArrayDisplay objectAtIndex:selectedRow];
	
	_renameFilePanel = [[AGEDFileRenamePanel alloc] initWithFile:file controller:self];
}

-(void)renameFilePanelAction:(AGEDFileRenamePanel*)sender
{
	AGEDFile* file = [sender editedFile];
	NSString* newFileName = [sender editedFileName];
	
	
	/*
	 //checks to see if user re-added path extension to file
	if ([[newFileName pathExtension] isEqualToString:[[file filename] pathExtension]]) {
		newFileName = [newFileName stringByDeletingPathExtension];
	}
	 */
	
	[self renameFile:file fileNameFormattingBlock:^(NSString* fileName){
		NSString* editedFileName = [[NSString stringWithFormat:@"%@", newFileName] stringByAppendingPathExtension:[fileName pathExtension]];
		return editedFileName;
	}];
	//can't use just NSApp delegate because does'nt respond to selector in new version of xcode for some reason
	AGEDAppDelegate* appDelegate = [NSApp delegate];
	[appDelegate reloadCurrentTable];
}

#pragma mark - NSTableViewDataSource methods Drag and Drop

- (id <NSPasteboardWriting>)tableView:(NSTableView *)tableView pasteboardWriterForRow:(NSInteger)row NS_AVAILABLE_MAC(10_7)
{
	NSURL *selectedURL = [self selectedFileURL:row];
	
	return selectedURL;
}



@end
