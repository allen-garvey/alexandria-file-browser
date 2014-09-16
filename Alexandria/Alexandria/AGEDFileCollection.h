//
//  AGEDFileCollection.h
//  Alexandria
//
//  Created by Allen Xavier on 7/24/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGEDFileCollection : NSObject

typedef NS_ENUM(NSInteger, AGEDFileCollectionOptions){
	AGEDDefaultNoOptionsCollection = -1,
	AGEDDefaultBookCollection,
	AGEDDefaultMusicCollection,
	AGEDDefaultMovieCollection,
	AGEDDefaultSheetMusicCollection,
	AGEDDefaultInternetCollection
};

typedef NS_ENUM(NSUInteger, AGEDFileSortDescriptorOptions){
	AGEDFileNameSortOption,
	AGEDFileCreationDateSortOption
};

//enum AGEDFileCollectionOptions{
//	AGEDDefaultBookCollection,
//	AGEDDefaultMusicCollection,
//	AGEDDefaultMovieCollection,
//	AGEDDefaultSheetMusicCollection,
//	AGEDDefaultInternetCollection
//};

@property BOOL removeDuplicateFilesBasedOnPathPriority;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSArray* supportedPathExtensions;
@property (strong, nonatomic) NSArray* categorySorterRegExPatterns;
@property (strong, nonatomic) NSArray* fileSortDescriptors;
@property (nonatomic) AGEDFileSortDescriptorOptions fileSortDescriptorsOption;

-(void)addFilesFromDirectories:(NSArray*) directories;
-(NSMutableArray*)fileArray;
-(NSDictionary*)serializeToDictionary;
-(AGEDFileCollection*)initFromDictionary:(NSDictionary*)serializedFileCollection;
-(NSArray*)directories;
-(void)genericSettings:(enum AGEDFileCollectionOptions)defaultType;
-(NSMutableArray*)duplicateFilesArray;
@end
