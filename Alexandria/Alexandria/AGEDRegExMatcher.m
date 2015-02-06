//
//  AGEDRegExMatcher.m
//  Alexandria
//
//  Created by Allen Xavier on 7/23/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDRegExMatcher.h"

@interface AGEDRegExMatcher()
@property (strong, nonatomic) NSRegularExpression* regExMatcher;

@end

@implementation AGEDRegExMatcher

-(id)initWithPattern:(NSString *)regExPattern
{
	self = [super init];
	if (self) {
		[self setRegExPattern:regExPattern];
	}
	return self;
}

-(AGEDRegExMatcher*)init
{
	self = [super init];
	if (self) {
		[self setRegExPattern:@""];
	}
	return self;
}

-(BOOL)isStringMatchCaseInsensitive:(NSString*)haystack
{
	if ([[_regExMatcher matchesInString:haystack options:0 range:NSMakeRange(0, [haystack length])] count] > 0 ){
		return true;
	}
	
	return false;
}

-(BOOL)isStringMatchCaseInsensitive:(NSString*)haystack regExPattern:(NSString*)regExPattern
{
	[self setRegExPattern:regExPattern];
	if ([self isStringMatchCaseInsensitive:haystack]){
		return true;
	}
	
	return false;
}

-(BOOL)isFileMatchCaseInsensitive:(AGEDFile *)file
{
	if ([self isStringMatchCaseInsensitive:[file filename]] || [self isStringMatchCaseInsensitive:[file category]]  || [self isStringMatchCaseInsensitive:[file directory]]){
		return true;
	}
	
	return false;
}

-(BOOL)isFileMatchCaseInsensitive:(AGEDFile*)file regExPattern:(NSString*)regExPattern
{
	[self setRegExPattern:regExPattern];
	return [self isFileMatchCaseInsensitive:file];
}

-(void)setRegExMatcher
{
	_regExMatcher = [NSRegularExpression regularExpressionWithPattern:_regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
}

-(void)setRegExPattern:(NSString *)regExPattern
{
	_regExPattern = regExPattern;
	[self setRegExMatcher];
}


@end
