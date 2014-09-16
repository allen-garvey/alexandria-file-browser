//
//  AGEDAlexandriaPreferencesWindow.h
//  Window Creation Test
//
//  Created by Allen Xavier on 8/11/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AGEDPreferencesController;

@interface AGEDAlexandriaPreferencesWindow : NSWindow

//adding AGEDPreferencesWindowController directly breaks the build
@property (weak, nonatomic) id<NSTableViewDataSource, AGEDPreferencesController> controller;

@property (strong, nonatomic) AGEDFileCollection* displayedFileCollection;

-(instancetype)initWithController:(id<NSTableViewDataSource, AGEDPreferencesController>) controller;

-(void)changeFileCollectionPopUpButtonTitles:(NSArray *)fileCollectionTitles selectedItemIndex:(NSInteger)index;
-(void)refreshAllTables;


@end

@protocol AGEDPreferencesController <NSObject>

-(void)setPreferencesWindow:(AGEDAlexandriaPreferencesWindow*)preferencesWindow;
- (NSArray*)fileCollectionTitles;
-(void)setIndexOfSelectedFileCollection:(NSInteger)indexOfSelectedFileCollection;
-(void)saveFileCollection:(AGEDFileCollection*)fileCollection;

@end
