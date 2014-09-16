//
//  AGEDAlexandriaUtil.m
//  Alexandria
//
//  Created by Allen Xavier on 7/27/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDAlexandriaUtil.h"

@implementation AGEDAlexandriaUtil

+(NSString*)trimWhiteSpace:(NSString *)string
{
	NSArray* stringSplitAtWhiteSpace = [string componentsSeparatedByString:@" "];
	NSString* trimmedString = @"";
	for (NSString* s in stringSplitAtWhiteSpace) {
		trimmedString = [NSString stringWithFormat:@"%@%@", trimmedString, s];
	}
	
	return trimmedString;
}

@end
