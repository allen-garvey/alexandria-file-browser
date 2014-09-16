//
//  AGEDAppDelegate.h
//  Alexandria
//
//  Created by Allen Xavier on 7/28/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AGEDAlexandriaPreferencesWindow.h"
#import "AGEDPreferencesWindowController.h"

@interface AGEDAppDelegate : NSObject <NSApplicationDelegate>

enum AGEDFileTypesDisplayedOptions{
		AGEDAllFilesOption,
		AGEDNonDuplicateFilesOption,
		AGEDDuplicateFilesOption
};

@property (weak) IBOutlet NSPopUpButton *filesDisplayedPopUpButton;
- (IBAction)filesDisplayedButtonAction:(id)sender;

@property (weak) IBOutlet NSButton *refreshButton;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTabView *topTabView;
@property (weak) IBOutlet NSButton *showInFinderButtonPressed;
@property (strong, nonatomic) NSMutableArray* agedTableViewControllerArray;
@property (strong, nonatomic) NSMutableArray* fileCollectionsArray;
@property (strong, nonatomic) AGEDTableViewController* selectedController;
@property (weak) IBOutlet NSSearchField *searchBar;
@property (strong, nonatomic) AGEDFileRenamePanel* renameFilePanel;
@property (strong, nonatomic) AGEDAlexandriaPreferencesWindow* preferencesWindow;
@property (strong, nonatomic) AGEDPreferencesWindowController* preferencesWindowController;

@property (weak) IBOutlet NSTextField *fileDisplayedLabel;
- (IBAction)openFileButtonPressed:(id)sender;
- (IBAction)searchTextEntered:(id)sender;
- (IBAction)showInFinderButtonPressed:(id)sender;
- (IBAction)refreshButtonAction:(id)sender;
-(IBAction)renameFileButtonAction:(id)sender;
- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem;
@property (weak) IBOutlet NSMenu *tableViewRightClickMenu;

-(IBAction)capitalizeFileNames:(id)sender;
-(IBAction)uppercaseFileNames:(id)sender;
-(IBAction)lowercaseFileNames:(id)sender;
-(void)reloadCurrentTable;
-(IBAction)showPreferencesAction:(id)sender;
@end
