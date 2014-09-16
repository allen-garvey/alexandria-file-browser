//
//  AGEDPreferencesWindowController.h
//  Alexandria
//
//  Created by Allen Xavier on 8/25/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGEDPreferencesWindowController : NSObject <NSTableViewDataSource, AGEDPreferencesController>

@property (strong, nonatomic) AGEDAlexandriaPreferencesWindow* preferencesWindow;
@property (strong, nonatomic) NSArray* fileCollectionsArray;
@property (nonatomic) NSInteger indexOfSelectedFileCollection;

-(instancetype)initWithFileCollectionsArray:(NSArray*)fileCollectionsArray;

- (NSArray*)fileCollectionTitles;

//needs to be added to - placeholder for now
-(void)saveFileCollection:(AGEDFileCollection*)fileCollection;


@end
