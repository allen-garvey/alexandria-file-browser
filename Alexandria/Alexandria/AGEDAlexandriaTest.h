//
//  AGEDAlexandriaTest.h
//  Alexandria
//
//  Created by Allen Xavier on 7/25/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGEDAlexandriaTest : NSObject

+(void)testFileCollection;
+(void)testFileCollectionToDictionary;
+(void)testFileCollectionFromDictionary;
+(void)enumTest;
+(void)trimWhiteSpaceTest;
+(void)testAddTab:(NSTabView*)topTabView;
+(AGEDFileCollection*)fileCollectionFromDictionary2;
+(AGEDFileCollection*)movieFileCollection;
+(AGEDFileCollection*)sheetMusicFileCollection;
-(AGEDFileCollection*)sheetMusicFileCollection;
+(AGEDFileCollection*)bookFileCollection;
-(AGEDFileCollection*)bookFileCollection;
+(AGEDFileCollection*)internetFileCollection;
+(void)fileContainsTest;
+(void)duplicateFilesTest;
+(void)moveFileToTrashTest;
+(void)moveFileToTrashTest2;
+(void)fileCollectionMutableCopyTest;

@end
