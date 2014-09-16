//
//  AGEDFileRenamePanel.h
//  file viewer prototype
//
//  Created by Allen Xavier on 8/8/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AGEDTableViewController;

@interface AGEDFileRenamePanel : NSPanel
@property (strong, nonatomic) NSView* mainView;
@property (strong, nonatomic) NSTextField* fileNameTextField;
@property (strong, nonatomic) NSTextField* fullFileNameLabel;
@property (strong, nonatomic) AGEDFile* editedFile;
@property (weak, nonatomic) id<AGEDTableViewController> controller;
@property (strong, nonatomic) NSString* editedFileName;
@property (strong, nonatomic) NSButton* saveButton;

-(instancetype)initWithFile:(AGEDFile*)editedFile controller:(id<AGEDTableViewController>)controller;
@end

