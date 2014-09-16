//
//  AGEDFile.h
//  Alexandria
//
//  Created by Allen Xavier on 7/23/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGEDFile : NSObject
@property (strong, nonatomic) NSString* filename;
@property (strong, nonatomic) NSString* directory;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSDictionary* fileInfo;
@property (strong, nonatomic, readonly) NSString* title;

-(void)openInDefaultApplication;
-(void)openInFinder;
-(NSInteger)fileSize;
-(NSString*)fileSizeString;
-(NSString*)fileCreationDateString;
-(NSDate*)fileCreationDate;
-(NSString *)fullFileName;

@end
