//
//  AGEDAlexandriaPreferencesWindow.m
//  Window Creation Test
//
//  Created by Allen Xavier on 8/11/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDAlexandriaPreferencesWindow.h"

@interface AGEDAlexandriaPreferencesWindow()
@property (strong, nonatomic) NSView* mainView;
@property (strong, nonatomic) NSPopUpButton* fileCollectionListPopUpButton;
@property (strong, nonatomic) NSPopUpButton* fileCollectionTypePopUpButton;
@property (strong, nonatomic) NSTextField* fileCollectionTitleTextField;
@property (strong, nonatomic) NSButton* showDuplicatedFilesCheckButton;
@property (strong, nonatomic) NSTableView* directoriesTableView;
@property (strong, nonatomic) NSTableView* supportedPathExtensionsTableView;
@property (strong, nonatomic) NSTableView* categoryTitlesAndPatternsTableView;
@property (strong, nonatomic) NSButton* saveButton;
@property (strong, nonatomic) NSButton* cancelButton;
@property (strong, nonatomic) NSSegmentedControl* editDirectoriesTableControl;
@property (strong, nonatomic) NSSegmentedControl* editPathExtensionsTableControl;
@property (strong, nonatomic) NSSegmentedControl* editCategoryTitlesAndPatternsTableControl;
@property (strong, nonatomic) NSMutableArray* tableViewArray;
@end

@implementation AGEDAlexandriaPreferencesWindow

- (instancetype)initWithController:(id<NSTableViewDataSource, AGEDPreferencesController>) controller
{
    self = [super init];
    if (self) {
        [self setController:controller];
		_tableViewArray = [NSMutableArray new];
		[self setFrame:NSRectFromString(@"{54,340,1052,303}") display:YES];
		_mainView = [[NSView alloc] initWithFrame:self.frame];
		
		_fileCollectionListPopUpButton = [[NSPopUpButton alloc] initWithFrame:NSRectFromString(@"{104,234,260,26}")];
//		[_tabListPopUpButton addItemWithTitle:@"New File Collection"];
		[self changeFileCollectionPopUpButtonTitles:[_controller fileCollectionTitles] selectedItemIndex:0];
		[_fileCollectionListPopUpButton setTarget:self];
		[_fileCollectionListPopUpButton setAction:@selector(fileCollectionListPopUpButtonAction)];
		[_mainView addSubview:_fileCollectionListPopUpButton];
		
		_fileCollectionTypePopUpButton = [[NSPopUpButton alloc] initWithFrame:NSRectFromString(@"{405,234,262,26}")];
		[_fileCollectionTypePopUpButton addItemsWithTitles:@[@"All Files Collection", @"Books Collection", @"Music Collection", @"Movies Collection", @"Internet Reading List Collection", @"Custom Collection"]];
		[_mainView addSubview:_fileCollectionTypePopUpButton];
		
		_fileCollectionTitleTextField = [[NSTextField alloc] initWithFrame:NSRectFromString(@"{705,238,255,22}")];
		[[_fileCollectionTitleTextField cell] setPlaceholderString:@"File Collection Title"];
		[[_fileCollectionTitleTextField cell] setScrollable:YES];
		[_mainView addSubview:_fileCollectionTitleTextField];
		
		
		_directoriesTableView = [NSTableView new];
		
		NSDictionary* directoryTableAttributes = @{@"table" : _directoriesTableView,
												   @"tableID" : @"directoriesTable",
												   @"containerFrameDimensions" : @"{22,75,323,152}",
												   @"columnCount" : @(1),
												   @"column1ID" : @"directoriesColumn",
												   @"column1Title" : @"Directories",
												   @"column1MinWidth" : @(303),
												   @"column1SortDescriptor" : [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)],
												   @"segmentedControlFrameDimensions" : @"{22,54,51,23}",
												   @"spacerGradientButtonFrameDimensions" : @"{72,54,273,23}"};
		
		[self createSettingsTable:directoryTableAttributes];
		
		_categoryTitlesAndPatternsTableView = [NSTableView new];
		
		NSDictionary* categoryTitlesAndPatternsTableAttributes = @{@"table" : _categoryTitlesAndPatternsTableView,
													@"tableID" : @"categoryTitlesAndPatternsTable",
												   @"containerFrameDimensions" : @"{557,75,475,152}",
												   @"columnCount" : @(2),
												   @"column1ID" : @"categoryTitleColumn",
												   @"column1Title" : @"Category Title",
												   @"column1MinWidth" : @(106),
												   @"column1SortDescriptor" : [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)],
												   @"column2ID" : @"categoryRegExColumn",
												   @"column2Title" : @"Category Regular Expression",
												   @"column2MinWidth" : @(341),
												   @"column2SortDescriptor" : [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)],
																   
													@"segmentedControlFrameDimensions" : @"{557,54,51,23}",
												   @"spacerGradientButtonFrameDimensions" : @"{607,54,425,23}"};
		
		[self createSettingsTable:categoryTitlesAndPatternsTableAttributes];
		
		_supportedPathExtensionsTableView = [NSTableView new];
		
		NSDictionary* supportedPathExtensionsTableAttributes = @{@"table" : _supportedPathExtensionsTableView,
																 @"tableID" : @"supportedPathExtensionsTable",
																   @"containerFrameDimensions" : @"{386,75,121,152}",
																   @"columnCount" : @(1),
																   @"column1ID" : @"supportedPathExtensionsColumn",
																   @"column1Title" : @"File Extensions",
																   @"column1MinWidth" : @(101),
																   @"column1SortDescriptor" : [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)],
																   
																   @"segmentedControlFrameDimensions" : @"{386,54,51,23}",
																   @"spacerGradientButtonFrameDimensions" : @"{436,54,71,23}"};
		[self createSettingsTable:supportedPathExtensionsTableAttributes];
		
		
		_saveButton = [[NSButton alloc]initWithFrame:NSRectFromString(@"{956, 13,82,32}")];
		[_saveButton setTitle:@"Save"];
		[_saveButton setBezelStyle:NSRoundedBezelStyle];
		[[_saveButton cell] setKeyEquivalent:@"\r"];
		[_saveButton setTarget:self];
		[_saveButton setAction:@selector(saveButtonAction)];
		[_mainView addSubview:_saveButton];
		
		_cancelButton = [[NSButton alloc]initWithFrame:NSRectFromString(@"{846, 13,82,32}")];
		[_cancelButton setTitle:@"Cancel"];
		[_cancelButton setBezelStyle:NSRoundedBezelStyle];
		[_cancelButton setTarget:self];
		[_cancelButton setAction:@selector(cancelOperation:)];
		[_mainView addSubview:_cancelButton];
		
		_showDuplicatedFilesCheckButton = [[NSButton alloc]initWithFrame:NSRectFromString(@"{20,18,228,18}")];
		[_showDuplicatedFilesCheckButton setTitle:@"Show Duplicated Files By Default"];
		[_showDuplicatedFilesCheckButton setButtonType:NSSwitchButton];
		[_showDuplicatedFilesCheckButton setState:NSOnState];
		[_mainView addSubview:_showDuplicatedFilesCheckButton];
		
		[self setStyleMask:15];
		[self setShowsResizeIndicator:YES];
		[self setContentView:_mainView];
		[self setTitle:@"Alexandria Preferences"];
		[self center];
//		[self setIsVisible:YES];
    }
    return self;
}


-(void)createSettingsTable:(NSDictionary*)tableAttributes
{
	NSTableView* table = tableAttributes[@"table"];
	[table setIdentifier:tableAttributes[@"tableID"]];
	[table setUsesAlternatingRowBackgroundColors:YES];
	[table setDataSource:_controller];
	[_tableViewArray addObject:table];
	
	NSScrollView* tableContainer = [[NSScrollView alloc] initWithFrame:NSRectFromString(tableAttributes[@"containerFrameDimensions"])];
	[tableContainer setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	
	[tableContainer setBorderType:NSBezelBorder];
	[tableContainer setHasHorizontalScroller:YES];
	[tableContainer setHasVerticalScroller:YES];
	
	[table setFrame:tableContainer.bounds];
	[table setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	
	NSInteger columnCount = [tableAttributes[@"columnCount"] integerValue];
	
	for (int i=1; i<=columnCount; i++) {
		NSTableColumn* tableColumn = [[NSTableColumn alloc] initWithIdentifier:tableAttributes[[NSString stringWithFormat:@"column%dID", i]]];
		[tableColumn.headerCell setTitle:tableAttributes[[NSString stringWithFormat:@"column%dTitle", i]]];
		[tableColumn setMinWidth:[tableAttributes[[NSString stringWithFormat:@"column%dMinWidth", i]] integerValue]];
		[tableColumn setWidth:[tableColumn minWidth]+15];
		//change descriptor later if choosing to make sortable
//		[tableColumn setSortDescriptorPrototype:tableAttributes[[NSString stringWithFormat:@"column%dSortDescriptor", i]]];
		[table addTableColumn:tableColumn];
	}
	
	[tableContainer setDocumentView:table];
	[_mainView addSubview:tableContainer];
	
	NSSegmentedControl* segmentedControl = [[NSSegmentedControl alloc] initWithFrame:NSRectFromString(tableAttributes[@"segmentedControlFrameDimensions"])];
	[segmentedControl setSegmentStyle:NSSegmentStyleSmallSquare];
	
	NSSegmentedCell* segmentCell = [segmentedControl cell];
	[segmentCell setSegmentCount:2];
	[segmentCell setTrackingMode:NSSegmentSwitchTrackingMomentary];
	
	[segmentCell setWidth:25 forSegment:0];
	[segmentCell setImage:[NSImage imageNamed:@"NSAddTemplate"] forSegment:0];
	
	[segmentCell setWidth:26 forSegment:1];
	[segmentCell setImage:[NSImage imageNamed:@"NSRemoveTemplate"] forSegment:1];
	
	[_mainView addSubview:segmentedControl];
	
	NSButton* spacerGradientButton = [[NSButton alloc] initWithFrame:NSRectFromString(tableAttributes[@"spacerGradientButtonFrameDimensions"])];
	[spacerGradientButton setTitle:@""];
	NSCell* spacerButtonCell = [spacerGradientButton cell];
	[spacerButtonCell setBezeled:YES];
	[spacerButtonCell setBordered:YES];
	[spacerGradientButton setBezelStyle:NSSmallSquareBezelStyle];
	
	[spacerGradientButton setButtonType:NSMomentaryChangeButton];
	[_mainView addSubview:spacerGradientButton];
}

-(void)cancelOperation:(id)sender
{
	[self setIsVisible:NO];
}

-(void)setController:(id<NSTableViewDataSource,AGEDPreferencesController>)controller
{
	_controller = controller;
	[controller setPreferencesWindow:self];
}

-(void)changeFileCollectionPopUpButtonTitles:(NSArray *)fileCollectionTitles selectedItemIndex:(NSInteger)index
{
	[_fileCollectionListPopUpButton removeAllItems];
	for (NSString* title in fileCollectionTitles) {
		[_fileCollectionListPopUpButton addItemWithTitle:title];
	}
	[_fileCollectionListPopUpButton selectItemAtIndex:index];
}

-(void)fileCollectionListPopUpButtonAction
{
	[_controller setIndexOfSelectedFileCollection:[_fileCollectionListPopUpButton indexOfSelectedItem]];
}

-(void)refreshAllTables
{
	for (NSTableView* table in _tableViewArray) {
		[table reloadData];
	}
}

-(void)setDisplayedFileCollection:(AGEDFileCollection *)displayedFileCollection
{
	_displayedFileCollection = displayedFileCollection;
	 [_fileCollectionTitleTextField setStringValue:[_displayedFileCollection title]];
	if ([_displayedFileCollection removeDuplicateFilesBasedOnPathPriority]) {
		[_showDuplicatedFilesCheckButton setState:NSOffState];
	}
	else{
		[_showDuplicatedFilesCheckButton setState:NSOnState];
	}
}

-(void)saveButtonAction
{
	if ([_showDuplicatedFilesCheckButton state] == NSOnState) {
		[_displayedFileCollection setRemoveDuplicateFilesBasedOnPathPriority:NO];
	}
	else{
		[_displayedFileCollection setRemoveDuplicateFilesBasedOnPathPriority:YES];
	}
	[_displayedFileCollection setTitle:[_fileCollectionTitleTextField stringValue]];
	
	[_controller saveFileCollection:_displayedFileCollection];
}

@end
