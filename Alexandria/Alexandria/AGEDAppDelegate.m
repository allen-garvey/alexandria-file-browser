//
//  AGEDAppDelegate.m
//  Alexandria
//
//  Created by Allen Xavier on 7/28/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDAppDelegate.h"
#import "AGEDAlexandriaTest.h"

@implementation AGEDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//		[AGEDAlexandriaTest fileContainsTest];
//[AGEDAlexandriaTest testFileCollectionToDictionary];
//[AGEDAlexandriaTest testFileCollectionFromDictionary];
	//	[AGEDAlexandriaTest enumTest];
	//	[AGEDAlexandriaTest trimWhiteSpaceTest];
	//	[AGEDAlexandriaTest testAddTab:_topTabView];
//	[AGEDAlexandriaTest duplicateFilesTest];
//	[AGEDAlexandriaTest moveFileToTrashTest];
//	[AGEDAlexandriaTest fileCollectionMutableCopyTest];
	
	NSLog(@"start");
	_agedTableViewControllerArray = [NSMutableArray new];

	_fileCollectionsArray = [NSMutableArray new];
//	[self addFileCollectionsNormally];
	[self addFileCollectionsConcurrent];
	
	NSLog(@"got file Collections");
	
	NSLog(@"finish");
}

-(void)addFileCollectionsNormally
{
	NSArray* testFileCollectionsArray = @[[AGEDAlexandriaTest bookFileCollection], [AGEDAlexandriaTest movieFileCollection], [AGEDAlexandriaTest sheetMusicFileCollection], [AGEDAlexandriaTest internetFileCollection]];
	[_fileCollectionsArray addObjectsFromArray:testFileCollectionsArray];
	for (AGEDFileCollection* fileCollection in _fileCollectionsArray) {
		[self addTabToTabView:fileCollection];
	}
	_selectedController = _agedTableViewControllerArray[0];
	[_selectedController updateFileCountLabel];
	[_window setIsVisible:YES];
	
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
	if (!flag) {
		[_window setIsVisible:true];
		
	}
	else{
		[_window setIsMiniaturized:false];
	}
	
	return NO;
}

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
	[_searchBar setStringValue:@""];
	[_selectedController resetTableToDefaults];
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
	NSInteger selectedTab = [_topTabView indexOfTabViewItem:[_topTabView selectedTabViewItem]];
	_selectedController = _agedTableViewControllerArray[selectedTab];
	[_selectedController updateFileCountLabel];
	
	[_filesDisplayedPopUpButton selectItemAtIndex:[_selectedController tableViewState]];
	
}


- (IBAction)openFileButtonPressed:(id)sender {
	[self openSelectedFile];
}

- (IBAction)searchTextEntered:(id)sender {
	NSSearchField* searchField = sender;
	[self displaySearchResults:[searchField stringValue]];
}

- (IBAction)showInFinderButtonPressed:(id)sender {
	[self showSelectedFileInFinder];
}

- (IBAction)refreshButtonAction:(id)sender
{
	[self reloadCurrentTable];
}


-(void)openSelectedFile
{
	[self mapSelectedRows:^(NSUInteger index, BOOL *stop){
		[_selectedController openSelectedFileInDefaultApp:index];
	}];
}

-(void)showSelectedFileInFinder
{
	[self mapSelectedRows:^(NSUInteger index, BOOL *stop){
		[_selectedController displaySelectedFileInFinder:index];
	}];

}

-(void)displaySearchResults:(NSString*)searchRegEx
{
	[_selectedController displaySearchResults:searchRegEx];
}

//-(void)refreshCurrentTable
//{
//	[_selectedController refreshTable];
//}


- (IBAction)filesDisplayedButtonAction:(id)sender {
	NSInteger selectedIndex = [_filesDisplayedPopUpButton indexOfSelectedItem];
	[_selectedController setTableViewState:selectedIndex];
	[self displaySearchResults:[_searchBar stringValue]];

}

//method used when delete menu item is pressed
-(void)delete:(id)sender
{
	[self mapSelectedRows:^(NSUInteger index, BOOL *stop){
		[_selectedController trashSelectedFile:index];
	}];
	//deselects selected rows
	[[[_selectedController tabViewItem] mainTableView] deselectAll:nil];
	
	//plays trash sound - only works OSX 10.7 and later because sound was in different directory before
	[[[NSSound alloc] initWithContentsOfFile:@"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/dock/drag to trash.aif" byReference:YES] play];
	
	[self reloadCurrentTable];
}

-(void)copy:(id)sender
{
	NSMutableArray* selectedFileURLs = [NSMutableArray new];
	//used so that text editors will have the file paths in pastboard for copying
	__block NSString* selectedFilePaths = @"";
	
	[self mapSelectedRows:^(NSUInteger index, BOOL *stop){
		AGEDFile* file =  [_selectedController selectedFile:index];
		[selectedFileURLs addObject:[[NSURL alloc] initFileURLWithPath:[file fullFileName] isDirectory:NO]];
		selectedFilePaths = [selectedFilePaths stringByAppendingString:[[file fullFileName] stringByAppendingString:@"\n"]];
	}];
	
	NSPasteboard* pasteboard = [NSPasteboard generalPasteboard];
	[pasteboard clearContents];
	[pasteboard writeObjects:selectedFileURLs];
	[pasteboard setString:selectedFilePaths forType:NSStringPboardType];
	
}

-(NSArray*)selectedRows
{
	//naive version since don't know how to extract row indexes from nsindexset
	
	NSInteger numberOfRowsInTable = [[[_selectedController tabViewItem] mainTableView] numberOfRows];
	NSIndexSet* selectedRows = [[[_selectedController tabViewItem] mainTableView] selectedRowIndexes];
	NSInteger rowsSelectedCount = [selectedRows count];
	NSMutableArray* indexes = [NSMutableArray new];
	for (NSInteger i=0; i<numberOfRowsInTable; i++) {
		if ([selectedRows containsIndex:(i)]) {
			[indexes addObject:@(i)];
		}
		if ([indexes count] == rowsSelectedCount) {
			break;
		}
	}
	return indexes;
}

-(IBAction)capitalizeFileNames:(id)sender
{
	[self mapSelectedRows:^(NSUInteger index, BOOL *stop){
		[_selectedController capitalizeFileName:index];
	}];
	
	[self reloadCurrentTable];
}

-(IBAction)uppercaseFileNames:(id)sender
{
	[self mapSelectedRows:^(NSUInteger index, BOOL *stop){
		[_selectedController upperCaseFileName:index];
	}];
	
	[self reloadCurrentTable];
}

-(IBAction)lowercaseFileNames:(id)sender
{
	[self mapSelectedRows:^(NSUInteger index, BOOL *stop){
		[_selectedController lowerCaseFileName:index];
	}];
	
	[self reloadCurrentTable];
}


-(void)mapSelectedRows:(void (^)(NSUInteger idx, BOOL *stop))block
{
	NSIndexSet* selectedRows = [[[_selectedController tabViewItem] mainTableView] selectedRowIndexes];
	[selectedRows enumerateIndexesUsingBlock:block];
}

-(IBAction)newTab:(id)sender
{
	[self addTabToTabView:[AGEDFileCollection new]];
}

-(void)addTabToTabView:(AGEDFileCollection*)fileCollection
{
	AGEDFileTabViewItem2* tabViewItem = [AGEDFileTabViewItem2 new];
	
	AGEDTableViewController* controller = [AGEDTableViewController new];
	[controller setFileCollection:fileCollection];
	[controller setFileCountLabel:_fileDisplayedLabel];
	[controller setTableViewRightClickMenu:_tableViewRightClickMenu];
	[_agedTableViewControllerArray addObject:controller];
	[controller setTabViewItem:tabViewItem];
	[_topTabView addTabViewItem:tabViewItem];
}

-(void)addTabToTabView:(AGEDFileCollection*)fileCollection indexPosition:(NSUInteger)index
{
	AGEDFileTabViewItem2* tabViewItem = [AGEDFileTabViewItem2 new];
	
	AGEDTableViewController* controller = [AGEDTableViewController new];
	[controller setFileCollection:fileCollection];
	[controller setFileCountLabel:_fileDisplayedLabel];
	[controller setTableViewRightClickMenu:_tableViewRightClickMenu];
	[_agedTableViewControllerArray replaceObjectAtIndex:index withObject:controller];
	[controller setTabViewItem:tabViewItem];
	[_topTabView insertTabViewItem:tabViewItem atIndex:index];
	

}

-(void)renameFileButtonAction:(id)sender
{
	[self mapSelectedRows:^(NSUInteger index, BOOL *stop){
		[_selectedController displayRenameFilePanel:index];
	}];
}

-(void)reloadCurrentTable
{
	[_selectedController refreshTable];
	[self displaySearchResults:[_searchBar stringValue]];
}

-(void)showPreferencesAction:(id)sender
{
	if(!_preferencesWindow){
		_preferencesWindowController = [[AGEDPreferencesWindowController alloc] initWithFileCollectionsArray:_fileCollectionsArray];
		_preferencesWindow =  [[AGEDAlexandriaPreferencesWindow alloc] initWithController:_preferencesWindowController];
		[_preferencesWindowController setIndexOfSelectedFileCollection:0];
	}
	[_preferencesWindow setIsVisible:YES];
}

-(void)addFileCollectionsConcurrent
{
	//initializes all the tabs to blank tabs and adds a loading... title so something will be there until the tab loads
	NSMutableArray* blankTabViewArray = [NSMutableArray new];
	int numberOfTabs = 4;
	
	for (int i=0; i<numberOfTabs; i++) {
		AGEDTableViewController* blankController = [AGEDTableViewController new];
		[_agedTableViewControllerArray addObject:blankController];
		NSTabViewItem* blankTabView = [NSTabViewItem new];
		[blankTabView setLabel:@"Loading..."];
		[_topTabView addTabViewItem: blankTabView];
		[blankTabViewArray addObject:blankTabView];
	}
	
	//loads first tab on main thread and shows window when done, then loads each following tab in order on a separate thread
	
	AGEDFileCollection* fileCollection = [AGEDAlexandriaTest bookFileCollection];
	
	NSLog(@"%@", [fileCollection directories]);
	

	[_fileCollectionsArray addObject: fileCollection];
	[self addTabToTabView:fileCollection indexPosition:0];
	_selectedController = _agedTableViewControllerArray[0];
	[_selectedController updateFileCountLabel];
	[_topTabView selectTabViewItemAtIndex:0];
	[_topTabView removeTabViewItem:[blankTabViewArray objectAtIndex:0]];
	[_window setIsVisible:YES];
	
		
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		AGEDAlexandriaTest* test = [AGEDAlexandriaTest new];
		NSArray *fileCollectionSelectorNames = @[@"movieFileCollection", @"sheetMusicFileCollection", @"internetFileCollection"];
		
		int i = 1;
		for (NSString *selectorName in fileCollectionSelectorNames) {
			AGEDFileCollection* fileCollection = [test performSelector:NSSelectorFromString(selectorName)];
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[_fileCollectionsArray addObject: fileCollection];
				[self addTabToTabView:fileCollection indexPosition:i];
				[_topTabView removeTabViewItem:[blankTabViewArray objectAtIndex:i]];
			});
			i++;
		}
    });
	
}



@end
