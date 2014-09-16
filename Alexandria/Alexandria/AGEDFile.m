//
//  AGEDFile.m
//  Alexandria
//
//  Created by Allen Xavier on 7/23/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDFile.h"

@implementation AGEDFile

-(void)setFilename:(NSString *)filename
{
	_filename = filename;
	_title = [_filename stringByDeletingPathExtension];
}

-(NSString *)fullFileName
{
	return [_directory stringByAppendingPathComponent:_filename];
}

-(void)openInDefaultApplication
{
	[[NSWorkspace sharedWorkspace] openFile:[self fullFileName]];
}

-(void)openInFinder
{
	
	[[NSWorkspace sharedWorkspace] selectFile:[self fullFileName] inFileViewerRootedAtPath:nil];
}
-(NSInteger)fileSize
{
	NSString* fileSize = _fileInfo[@"NSFileSize"];
	return [fileSize integerValue];
}

-(NSString*)fileSizeString
{
	return [NSByteCountFormatter stringFromByteCount:[self fileSize] countStyle:NSByteCountFormatterCountStyleFile];
}

-(NSString*)fileCreationDateString
{
	return [NSDateFormatter localizedStringFromDate:_fileInfo[@"NSFileCreationDate"] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
}
-(NSDate*)fileCreationDate
{
	return _fileInfo[@"NSFileCreationDate"];
}

-(BOOL)isEqual:(id)object
{
	if ([[self title] isEqualToString:[object title]]) {
		return true;
	}
	return false;
}

-(int) compare: (AGEDFile *)f
{
	return [_filename compare:[f filename]];
}

-(NSString*)description
{
	return [self filename];
}

-(NSUInteger)hash
{
	return [[self title] hash];
}

@end
