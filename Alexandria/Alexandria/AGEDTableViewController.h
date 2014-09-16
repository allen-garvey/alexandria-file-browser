//
//  AGEDTableViewController.h
//  Alexandria
//
//  Created by Allen Xavier on 7/28/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AGEDFileTabViewItem2.h"
#import "AGEDFileRenamePanel.h"

@interface AGEDTableViewController : NSObject <NSTableViewDataSource, AGEDTableViewController>

typedef NS_ENUM(NSInteger, AGEDTableViewState) {
	AGEDAllFilesView,
	AGEDNonDuplicateFilesView,
	AGEDDuplicateFilesView
};

@property (weak, nonatomic) AGEDFileTabViewItem2 *tabViewItem;
@property (strong, nonatomic) AGEDFileCollection* fileCollection;
@property (weak, nonatomic) NSTextField* fileCountLabel;
@property (nonatomic) BOOL fileDuplicatesDisplayed;
@property (nonatomic) AGEDTableViewState tableViewState;
@property (weak, nonatomic) NSMenu* tableViewRightClickMenu;


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors;

-(void)displaySearchResults:(NSString*)searchRegEx;

-(void)openSelectedFileInDefaultApp:(NSUInteger)selectedRow;

//method created because unsure how to create selector with arguments
-(void)openSelectedFileInDefaultApp;

-(void)displaySelectedFileInFinder:(NSUInteger)selectedRow;

-(void)updateView;

-(void)updateFileCountLabel;

//used to reset the table when changing tabs since a search would have altered the table
-(void)resetTableToDefaults;

//used to reset the table if it is using the AGEDShowDuplicateFilesOption
-(void)refreshTable;

//-(void)setTableViewSortDescriptors:(NSArray*)descriptors;

-(void)trashSelectedFile:(NSUInteger)selectedRow;

-(void)tableViewRightClickAction:(NSEvent*)theEvent;;

-(void)capitalizeFileName:(NSUInteger)selectedRow;
-(void)upperCaseFileName:(NSUInteger)selectedRow;
-(void)lowerCaseFileName:(NSUInteger)selectedRow;

-(void)displayRenameFilePanel:(NSUInteger)selectedRow;
-(void)renameFilePanelAction:(AGEDFileRenamePanel*)sender;



@end
