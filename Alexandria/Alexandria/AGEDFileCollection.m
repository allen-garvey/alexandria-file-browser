//
//  AGEDFileCollection.m
//  Alexandria
//
//  Created by Allen Xavier on 7/24/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDFileCollection.h"

@interface AGEDFileCollection()

@property (strong, nonatomic) NSMutableArray* fileArray;
@property (strong, nonatomic) AGEDFileCategorySorter* sorter;
@property (strong, nonatomic) NSMutableArray* directories;
@property (strong, nonatomic) NSSet* supportedPathExtensionsSet;
@property (nonatomic)NSUInteger categoryPatternsCount;
@property (nonatomic)BOOL addAllFileTypes;
@property (strong, nonatomic)NSMutableArray* duplicateFilesArray;

@end

@implementation AGEDFileCollection

-(id)init
{
	self = [super init];
	
	if (self) {
		[self setRemoveDuplicateFilesBasedOnPathPriority:NO];
		[self setTitle:@""];
		[self setSupportedPathExtensions:@[]];
		[self setDirectories:[NSMutableArray new]];
		[self setSorter:[AGEDFileCategorySorter new]];
		_fileArray = [NSMutableArray new];
		[self setFileSortDescriptorsOption:AGEDFileNameSortOption];
	
	}
	
	return self;
}

-(AGEDFileCollection*)initFromDictionary:(NSDictionary *)serializedFileCollection
{
	self = [self init];
	
	if (self) {
		[self setRemoveDuplicateFilesBasedOnPathPriority: [serializedFileCollection[@"removeDuplicateFilesBasedOnPathPriority"] integerValue]];
		[self setTitle:serializedFileCollection[@"title"]];
		[self setSupportedPathExtensions:serializedFileCollection[@"supportedPathExtensions"]];
		[self setFileSortDescriptorsOption:[serializedFileCollection[@"fileSortDescriptorsOption"] unsignedIntegerValue]];
		[self setCategorySorterRegExPatterns:serializedFileCollection[@"categorySorterRegExPatterns"]];
		[self addFilesFromDirectories:serializedFileCollection[@"directories"]];
	}
	
	return self;
}

-(NSDictionary*)serializeToDictionary
{
	return @{@"title" : _title,  @"supportedPathExtensions" : _supportedPathExtensions, @"directories" : _directories, @"categorySorterRegExPatterns" : [self categorySorterRegExPatterns], @"removeDuplicateFilesBasedOnPathPriority" : @(_removeDuplicateFilesBasedOnPathPriority) , @"fileSortDescriptorsOption" : @(_fileSortDescriptorsOption)};
}

-(instancetype)mutableCopy
{
	NSDictionary* serializedSelf = [self serializeToDictionary];
	return [[AGEDFileCollection alloc] initFromDictionary:serializedSelf];
}

-(void)setCategorySorterRegExPatterns:(NSArray *)categorySorterRegExPatterns
{
//	self.categorySorterRegExPatterns = categorySorterRegExPatterns;
	_categoryPatternsCount = [categorySorterRegExPatterns count];
	[_sorter setCategoryTitlesAndPatterns:categorySorterRegExPatterns];
}

-(NSArray*)categorySorterRegExPatterns
{
	return [_sorter categoryTitlesAndPatterns];
}

-(void)addFile:(AGEDFile*)file
{
	[_fileArray addObject:file];
}

-(NSMutableArray*)fileArray
{
	return [_fileArray mutableCopy];
}

-(NSMutableArray*)removeDuplicates:(NSMutableArray*)fileArray
{
	if (!_removeDuplicateFilesBasedOnPathPriority || [_supportedPathExtensions count] <= 1) {
		return fileArray;
	}
	else{
		_duplicateFilesArray = [NSMutableArray new];
		NSMutableSet* fileArraySet = [NSMutableSet new];
		NSMutableSet* fileSet = [NSMutableSet new];
		NSMutableSet* stillToBeSorted = [NSMutableSet new];
		
		NSUInteger count = [fileArray count];
		for (int i=0; i<count; i++) {
			AGEDFile* file = fileArray[i];
			[fileArraySet addObject:file];
			if ([[[file filename] pathExtension] isEqualToString:_supportedPathExtensions[0]]) {
				if (![fileSet containsObject:file]) {
					[fileSet addObject:file];
				}
				else{
					[_duplicateFilesArray addObject:file];
				}
			}
			else{
				[stillToBeSorted addObject:file];
			}
		}

		fileArraySet = stillToBeSorted;
		stillToBeSorted = [NSMutableSet new];
		
		count = [_supportedPathExtensions count];
		for (int i=1; i<count; i++) {
			for (AGEDFile* file in fileArraySet) {
				if ([[[file filename] pathExtension] isEqualToString:_supportedPathExtensions[i]]) {
					if (![fileSet containsObject:file]) {
						[fileSet addObject:file];
					}
					else{
						[_duplicateFilesArray addObject:file];
					}
				}
				else{
					[stillToBeSorted addObject:file];
				}
			}
			fileArraySet = stillToBeSorted;
			stillToBeSorted = [NSMutableSet new];
		}
		for (AGEDFile* file in fileSet) {
			if ([_duplicateFilesArray containsObject:file]) {
				[_duplicateFilesArray addObject:file];
			}
		}
		return [[fileSet allObjects] mutableCopy];
	}
}

-(NSMutableArray*)duplicateFilesArray
{
	if (!_removeDuplicateFilesBasedOnPathPriority) {
//		sets _duplicatesFileArray because otherwise won't exist
		[self setRemoveDuplicateFilesBasedOnPathPriority:YES];
		[self removeDuplicates:_fileArray];
		[self setRemoveDuplicateFilesBasedOnPathPriority:NO];
	}
	return _duplicateFilesArray;
}

-(BOOL)isDirectory:(NSString*)filename directory:(NSString*)directory
{
	NSFileManager *fmTemp = [[NSFileManager alloc] init];
	[fmTemp changeCurrentDirectoryPath:directory];
	NSDictionary* fileInfo = [fmTemp attributesOfItemAtPath:filename error:nil];
	if ([fileInfo[NSFileType]  isEqual: NSFileTypeDirectory]) {
		return true;
	}
	
	return false;
}

-(NSDictionary*)fileInfo:(NSString*)filename directory:(NSString*)directory
{
	NSFileManager *fmTemp = [[NSFileManager alloc] init];
	[fmTemp changeCurrentDirectoryPath:directory];
	return [fmTemp attributesOfItemAtPath:filename error:nil];
}

-(void) addFilesFromDirectory:(NSString *)directory
{
	@autoreleasepool {
		
		NSFileManager *fmTemp = [[NSFileManager alloc] init];
		if (![fmTemp changeCurrentDirectoryPath:directory]) {
//				NSLog(@"%@ directory not found", directory);
			return;
		}
		
		NSArray *dirContents = [fmTemp contentsOfDirectoryAtPath:[fmTemp currentDirectoryPath] error: NULL];
		for (NSString *filename in dirContents){
			
			NSDictionary* fileInfo = [self fileInfo:filename directory:directory];
			
			if ([fileInfo[NSFileType]  isEqual: NSFileTypeDirectory]) {
				NSString *newDirectory = [directory stringByAppendingPathComponent:filename];
				[self addFilesFromDirectory:newDirectory];
			}
			else{
				if ([_supportedPathExtensionsSet containsObject:[[filename pathExtension] lowercaseString]] || _addAllFileTypes) {
					AGEDFile *file = [AGEDFile new];
					[file setDirectory:directory];
					[file setFilename:filename];
					[file setFileInfo:fileInfo];
					if (_categoryPatternsCount < 1) {
						[file setCategory:@""];
					}
					else{
						[file setCategory:[_sorter fileCategory:file]];
					}
					[self addFile:file];
				}
			}
		}
	}
}

-(void)addFilesFromDirectories:(NSArray *)directories
{
	for (NSString* directory in directories) {
		if (![_directories containsObject:directory]) {
			[_directories addObject:directory];
			[self addFilesFromDirectory:directory];
		}
	}
	_fileArray = [self removeDuplicates:_fileArray];
}



-(NSArray*)directories
{
	return _directories;
}

-(void)genericSettings:(enum AGEDFileCollectionOptions)defaultType
{
	NSArray* genericSupportedFileExtensions;
	NSArray* genericCategorySorterRegExPatterns;
	
	NSArray* genericBookSupportedFileExtensions = @[@"mobi", @"epub", @"pdf", @"cbr"];
	/*
	NSArray* genericBookCategorySorterRegExPatterns = @[
														@"Fitness",					@"bodybuild|muscle|fitness|excercise|diet|strength|conditioning|ball|stretch|pavel|chef|\\bbody\\b|\\bfood[s]?\\b|\\beat\\b",
														@"Graphic Design",			@"graphic|typography|photoshop|illustrator|adobe",
														@"Music",						@"music|reason.[0-9]*",
														@"XML",						@"xml",
														@"Math",						@"calculus|algebra|math",
														@"Economics",					@"economics",
														@"Business",					@"money|^earn|workweek|\\bwork\\b|\\$",
														@"Biography",					@"biography",
														@"Pickup",					@"women|red.pill|sex|roosh|charisma|attract|deangelo",
														@"Python",					@"python|django",
														@"Java",						@"java |j2ee",
														@"Objective-C",				@"objective.c|ios[0-9]*|cocoa",
														@"C",							@"[^0-9a-z]c[^0-9a-z]|^c[^0-9a-z]|[^0-9a-z]c$",
														@"Web Design",				@"html|css|javascript|php|rails|jquery|internet|web|cold.fusion",
														@"Databases",					@"database|sql",
														@"Operating Systems",			@"operating.system[s]?",
														@"Software Engineering",		@"software.engineering|software",
														@"Pyschology",				@"pyschology|anxiety",
														@"Science",					@"physics|chemistry|experiment|[^computer ]science|feynman",
														@"Self-Improvement",			@"self.improve|wisdom|mastery",
														@"Photography",				@"photography",
														@"Art",						@"\\bart\\b|\\bartist(s)?\\b|banksy",
														@"Spirituality",				@"spirituality|\\bgod\\b|[^0-9a-z]god[^0-9a-z]|^god[^0-9a-z]",
														@"Computer Programming",		@"program|computer|algorithm|regular.expression|schemer"
														];
	*/
	NSArray* genericMusicSupportedFileExtensions = @[@"mp3", @"aac", @"wav"];
	NSArray* genericMusicCategorySorterRegExPatterns = @[];
	
	NSArray* genericMovieSupportedFileExtensions = @[@"avi", @"mpg", @"mp4", @"divx", @"m4v", @"mkv"];
	NSArray* genericMovieCategorySorterRegExPatterns = @[];
	
	NSArray* genericSheetMusicSupportedFileExtensions = @[@"pdf"];
	NSArray* genericSheetMusicCategorySorterRegExPatterns = @[@"Hal Books", @"^[0-9]{3}",
															  @"Berklee", @"berklee|berkley",
															  @"Cruise Ships", @"proship|cruise",
															  @"Pickup", @"women|red.pill|sex|roosh|charisma|attract|deangelo",
															  @"Production Shows", @"production shows",
															  @"Barbershop", @"barbershop",
															  @"Fake Book", @"real book|fake book|anthology|songbook|real",
															  @"Bass", @"bass",
															  @"Jazz", @"jazz|james jamerson",
															  @"Musicals", @"musicals",
															  @"Violin", @"violin",
															  @"Cello", @"cello",
															  @"Guitar", @"guitar",
															  @"Transcriptions", @"transcription",
															  @"Other Stuff", @"other stuff|bus|archive|manual|school",
															  @"Piano", @"piano|chopin",
															  @"Rock", @"rock"];
	
	NSArray* genericInternetSupportedFileExtensions = @[@"html", @"pdf", @"webarchive"];
	NSArray* genericInternetCategorySorterRegExPatterns = @[
														@"Fitness",					@"bodybuild|muscle|fitness|excercise|diet|strength|conditioning|ball|stretch|pavel|chef|\\bbody\\b|\\bfood[s]?\\b|\\beat\\b|nutrition|training|p90x|nutrient",
														@"Graphic Design",			@"graphic|typography|photoshop|illustrator|adobe",
														@"XML",						@"xml",
														@"Math",						@"calculus|algebra|math",
														@"Business",					@"money|^earn|workweek|\\bwork\\b|\\$|credit|economics",
														@"Biography",					@"biography",
														@"Pickup",					@"women|red.pill|sex|roosh|charisma|attract|deangelo",
														@"Python",					@"python|django",
														@"Java",						@"java[^0-9a-z.]|java$|j2ee",
														@"Haskell",						@"haskell",
														@"Lisp",						@"lisp|schemer",
														@"Objective-C",				@"objective.c|ios[0-9]*|cocoa|coremidi|xcode|osx|swift",
														@"C",							@"[^0-9a-z.]c[^0-9a-z.]|^c[^0-9a-z.]|[^0-9a-z.]c$",
														@"PHP",						@"php|codeigniter",
														@"Javascript",				@"javascript|js|angular|jquery",
														@"Ruby",					@"ruby|rails",
														@"Web Design",				@"html|css|web|cold.fusion",
														@"Databases",					@"database|sql",
														@"Operating Systems",			@"operating.system[s]?",
														@"Software Engineering",		@"software.engineering|software|refactor",
														@"Pyschology",				@"pyschology|anxiety",
														@"Science",					@"physics|chemistry|experiment|[^computer ]science|feynman",
														@"Self-Improvement",			@"self.improve|wisdom|mastery",
														@"Photography",				@"photography|photo",
														@"Art",						@"\\bart\\b|\\bartist(s)?\\b|banksy",
														@"Music",						@"music|bass|jazz|lutherie|guitar|reason.[0-9]*|les.paul",
														@"Spirituality",				@"spirituality|\\bgod\\b|[^0-9a-z]god[^0-9a-z]|^god[^0-9a-z]",
														@"Computer Programming",		@"program|computer|algorithm|regular.expression",
														@"College",					@"college|ncc|textbook|course",
														@"Non-fiction",				@"reference|manual|primer|non.fiction"
														];
	
	
	genericSupportedFileExtensions = @[genericBookSupportedFileExtensions, genericMusicSupportedFileExtensions, genericMovieSupportedFileExtensions, genericSheetMusicSupportedFileExtensions, genericInternetSupportedFileExtensions];
	
	genericCategorySorterRegExPatterns = @[genericInternetCategorySorterRegExPatterns, genericMusicCategorySorterRegExPatterns, genericMovieCategorySorterRegExPatterns, genericSheetMusicCategorySorterRegExPatterns, genericInternetCategorySorterRegExPatterns];
	
	if (defaultType < 0 || defaultType >= [genericCategorySorterRegExPatterns count]) {
		return;
	}
	if (defaultType == AGEDDefaultInternetCollection || defaultType == AGEDDefaultMovieCollection) {
		[self setFileSortDescriptorsOption:AGEDFileCreationDateSortOption];
	}
	
	[self setCategorySorterRegExPatterns:genericCategorySorterRegExPatterns[defaultType]];
	[self setSupportedPathExtensions:genericSupportedFileExtensions[defaultType]];
}

-(void)setSupportedPathExtensions:(NSArray *)supportedPathExtensions
{
	_supportedPathExtensions = supportedPathExtensions;
	_supportedPathExtensionsSet = [NSSet setWithArray:supportedPathExtensions];
	if ([_supportedPathExtensions count] > 0) {
		_addAllFileTypes = false;
	}
	else{
		_addAllFileTypes = true;
	}
}

-(void)setFileSortDescriptorsOption:(AGEDFileSortDescriptorOptions)fileSortDescriptorOption
{
	_fileSortDescriptorsOption = fileSortDescriptorOption;
	NSArray *descriptors;
	if (fileSortDescriptorOption == AGEDFileCreationDateSortOption) {
		descriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"fileCreationDate" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES]];
		
	}
	else{
		descriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"directory" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"filename" ascending:YES]];
		
	}
	[self setFileSortDescriptors:descriptors];
}

@end
