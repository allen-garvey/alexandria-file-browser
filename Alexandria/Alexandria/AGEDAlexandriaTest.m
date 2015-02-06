//
//  AGEDAlexandriaTest.m
//  Alexandria
//
//  Created by Allen Xavier on 7/25/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDAlexandriaTest.h"

@implementation AGEDAlexandriaTest

+(void)testFileCollection
{
	NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dir =  [NSString stringWithFormat:@"%@/books", documentsFolders[0]];
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection setSupportedPathExtensions:@[@"mobi", @"pdf"]];
	[fileCollection addFilesFromDirectories:@[dir]];
	[fileCollection setRemoveDuplicateFilesBasedOnPathPriority:YES];
	NSMutableArray* files = [fileCollection fileArray];
	NSLog(@"%lu", (unsigned long)[files count]);
	[files sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]]];
	for (AGEDFile* file in files) {
		NSLog(@"%@", [file filename]);
	}
}

+(void)testFileCollectionFromDictionary
{
	NSFileManager* fm = [NSFileManager defaultManager];
	NSArray *dirList = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
	[fm changeCurrentDirectoryPath:dirList[0]];
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:@"serialized_file_array"];
	AGEDFileCollection* fileCollection = [[AGEDFileCollection alloc] initFromDictionary:dict];
	NSMutableArray* fileArray = [fileCollection fileArray];
	NSLog(@"%@", [fileCollection directories]);
	NSLog(@"%lu", (unsigned long)[fileArray count]);
	for (AGEDFile* file in fileArray) {
		NSLog(@"%@", [file filename]);
	}
	
}

+(void)testFileCollectionToDictionary
{
	NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dir =  [NSString stringWithFormat:@"%@/books", documentsFolders[0]];
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection setSupportedPathExtensions:@[@"mobi", @"pdf"]];
	[fileCollection setRemoveDuplicateFilesBasedOnPathPriority:YES];
	[fileCollection addFilesFromDirectories:@[dir]];
	[fileCollection setTitle:@"Books"];
	
	NSDictionary* dict = [fileCollection serializeToDictionary];
	
	NSFileManager* fm = [NSFileManager defaultManager];
	NSArray *dirList = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
	[fm changeCurrentDirectoryPath:dirList[0]];
	[dict writeToFile:@"serialized_file_array" atomically:NO];
}

+(void)enumTest
{
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	
	[fileCollection genericSettings:AGEDDefaultBookCollection];
	NSLog(@"%@", [fileCollection supportedPathExtensions]);
	NSLog(@"%@", [fileCollection categorySorterRegExPatterns]);
	
	[fileCollection genericSettings:AGEDDefaultMovieCollection];
	NSLog(@"%@", [fileCollection supportedPathExtensions]);
	NSLog(@"%@", [fileCollection categorySorterRegExPatterns]);
	
	[fileCollection genericSettings:AGEDDefaultMusicCollection];
	NSLog(@"%@", [fileCollection supportedPathExtensions]);
	NSLog(@"%@", [fileCollection categorySorterRegExPatterns]);
}

+(void)trimWhiteSpaceTest
{
	NSLog(@"%@", [AGEDAlexandriaUtil trimWhiteSpace:@"date      Created For"]);
}

+(void)testAddTab:(NSTabView *)topTabView
{
	AGEDFileTabViewItem2* tabViewItem = [AGEDFileTabViewItem2 new];
	AGEDFileCollection* fileCollection = [AGEDAlexandriaTest fileCollectionFromDictionary2];
	AGEDTableViewController* controller = [AGEDTableViewController new];
	[controller setFileCollection:fileCollection];
	[controller setTabViewItem:tabViewItem];

	[topTabView addTabViewItem: tabViewItem];
}

+(AGEDFileCollection*)fileCollectionFromDictionary2
{
	NSFileManager* fm = [NSFileManager defaultManager];
	NSArray *dirList = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
	[fm changeCurrentDirectoryPath:dirList[0]];
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:@"serialized_file_array"];
	AGEDFileCollection* fileCollection = [[AGEDFileCollection alloc] initFromDictionary:dict];
	return fileCollection;
}

+(AGEDFileCollection*)bookFileCollection
{
	NSLog(@"start loading books");
	NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *booksDir =  [NSString stringWithFormat:@"%@/books", documentsFolders[0]];
	NSArray *applicationSupport = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString* kindleDir = [NSString stringWithFormat:@"%@/kindle/my kindle content", applicationSupport[0]];
	
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection genericSettings:AGEDDefaultBookCollection];
	[fileCollection setRemoveDuplicateFilesBasedOnPathPriority:YES];
	[fileCollection addFilesFromDirectories:@[kindleDir, booksDir]];
	[fileCollection setTitle:@"Books"];
	NSLog(@"finish loading %@", [fileCollection title]);
	return fileCollection;
}

-(AGEDFileCollection*)bookFileCollection
{
	NSLog(@"start loading books");
	NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *booksDir =  [NSString stringWithFormat:@"%@/books", documentsFolders[0]];
	NSArray *applicationSupport = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString* kindleDir = [NSString stringWithFormat:@"%@/kindle/my kindle content", applicationSupport[0]];
	
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection genericSettings:AGEDDefaultBookCollection];
	[fileCollection setRemoveDuplicateFilesBasedOnPathPriority:YES];
	[fileCollection addFilesFromDirectories:@[kindleDir, booksDir]];
	[fileCollection setTitle:@"Books"];
	NSLog(@"finish loading %@", [fileCollection title]);
	return fileCollection;
}


+(AGEDFileCollection*)movieFileCollection
{
	NSLog(@"start loading movies");
	NSArray *movieDirList = NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES);
	NSString* movieDir = movieDirList[0];
	
//	NSArray *downloadsDirList = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
//	NSString* archiveDir = [downloadsDirList[0] stringByAppendingPathComponent:@"archive"];
	
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection genericSettings:AGEDDefaultMovieCollection];
	//[fileCollection addFilesFromDirectories:@[movieDir, archiveDir]];
	[fileCollection addFilesFromDirectories:@[movieDir]];
	[fileCollection setTitle:@"Movies"];
	NSLog(@"finish loading %@", [fileCollection title]);
	return fileCollection;
}

-(AGEDFileCollection*)movieFileCollection
{
	NSLog(@"start loading movies");
	NSArray *movieDirList = NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES);
	NSString* movieDir = movieDirList[0];
	
	//	NSArray *downloadsDirList = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
	//	NSString* archiveDir = [downloadsDirList[0] stringByAppendingPathComponent:@"archive"];
	
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection genericSettings:AGEDDefaultMovieCollection];
	//[fileCollection addFilesFromDirectories:@[movieDir, archiveDir]];
	[fileCollection addFilesFromDirectories:@[movieDir]];
	[fileCollection setTitle:@"Movies"];
	NSLog(@"finish loading %@", [fileCollection title]);
	return fileCollection;
}


+(AGEDFileCollection*)sheetMusicFileCollection
{
	NSLog(@"start loading sheet music");
	NSArray *dirList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* docDir = dirList[0];
	NSString* sheetMusicDir = [docDir stringByAppendingPathComponent:@"Sheet Music"];
	NSString* realBooksDir = [docDir stringByAppendingPathComponent:@"Real Books"];
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection genericSettings:AGEDDefaultSheetMusicCollection];
	[fileCollection addFilesFromDirectories:@[sheetMusicDir, realBooksDir]];
	[fileCollection setTitle:@"Sheet Music"];
	NSLog(@"finish loading %@", [fileCollection title]);
	return fileCollection;
}

-(AGEDFileCollection*)sheetMusicFileCollection
{
	NSLog(@"start loading sheet music");
	NSArray *dirList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* docDir = dirList[0];
	NSString* sheetMusicDir = [docDir stringByAppendingPathComponent:@"Sheet Music"];
	NSString* realBooksDir = [docDir stringByAppendingPathComponent:@"Real Books"];
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection genericSettings:AGEDDefaultSheetMusicCollection];
	[fileCollection addFilesFromDirectories:@[sheetMusicDir, realBooksDir]];
	[fileCollection setTitle:@"Sheet Music"];
	NSLog(@"finish loading %@", [fileCollection title]);
	return fileCollection;
}



+(AGEDFileCollection*)internetFileCollection
{
	NSLog(@"start loading internet");
	NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *internetDir =  [NSString stringWithFormat:@"%@/internet", documentsFolders[0]];
	
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection genericSettings:AGEDDefaultInternetCollection];
	[fileCollection addFilesFromDirectories:@[internetDir]];
	[fileCollection setTitle:@"Internet"];
	NSLog(@"finish loading %@", [fileCollection title]);
	return fileCollection;
}

-(AGEDFileCollection*)internetFileCollection
{
	NSLog(@"start loading internet");
	NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *internetDir =  [NSString stringWithFormat:@"%@/internet", documentsFolders[0]];
	
	AGEDFileCollection* fileCollection = [AGEDFileCollection new];
	[fileCollection genericSettings:AGEDDefaultInternetCollection];
	[fileCollection addFilesFromDirectories:@[internetDir]];
	[fileCollection setTitle:@"Internet"];
	NSLog(@"finish loading %@", [fileCollection title]);
	return fileCollection;
}


+(void)fileContainsTest
{
	AGEDFile* file1 = [AGEDFile new];
	[file1 setFilename:@"Lirael - Garth Nix.mobi"];
	AGEDFile* file2 = [AGEDFile new];
	[file2 setFilename:@"Lirael - Garth Nix.pdf"];
	
	NSMutableSet* set = [NSMutableSet new];
	[set addObject:file1];
//	NSSet* testSet = [NSSet setWithArray:[set allObjects]];
	if ([set containsObject:file2]) {
		NSLog(@"set contains file");
	}
	else{
		NSLog(@"set does not contain file");
	}
}

+(void)duplicateFilesTest
{
	AGEDFileCollection* bookFileCollection = [AGEDAlexandriaTest bookFileCollection];
	NSLog(@"%@", [bookFileCollection duplicateFilesArray]);
}

+(void)moveFileToTrashTest
{
	NSArray *desktopList = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
	NSString* desktop = desktopList[0];
	NSString* testFile = [desktop stringByAppendingPathComponent:@"test.txt"];
	NSURL* testFileUrl = [[NSURL alloc] initFileURLWithPath:testFile isDirectory:NO];
	
	NSFileManager* fm = [NSFileManager defaultManager];
	
	NSError* error;
	
	[fm trashItemAtURL:testFileUrl resultingItemURL:nil error:&error];
	if (error) {
		NSLog(@"%@", error);
	}
}

+(void)moveFileToTrashTest2
{
	NSArray *desktopList = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
	NSString* desktop = desktopList[0];
	NSString* testFile = [desktop stringByAppendingPathComponent:@"test.txt"];
	NSFileManager* fm = [NSFileManager defaultManager];
	NSError* error;
	[fm removeItemAtPath:testFile error:&error];
	if (error) {
		NSLog(@"%@", error);
	}
}

+(void)fileCollectionMutableCopyTest
{
	AGEDFileCollection* bookCollection = [AGEDAlexandriaTest bookFileCollection];
	[bookCollection setTitle:@"Book Collection 1"];
	NSDictionary* serializedBookCollection = [bookCollection serializeToDictionary];
	AGEDFileCollection* bookCollection2 = [[AGEDFileCollection alloc] initFromDictionary:serializedBookCollection];
	[bookCollection2 setSupportedPathExtensions:@[@"mp3"]];
	NSLog(@"%@", [bookCollection supportedPathExtensions]);
}

@end
