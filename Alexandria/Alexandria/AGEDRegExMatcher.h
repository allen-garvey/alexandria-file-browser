//
//  AGEDRegExMatcher.h
//  Alexandria
//
//  Created by Allen Xavier on 7/23/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGEDRegExMatcher : NSObject

@property (strong, nonatomic) NSString* regExPattern;

-(BOOL)isStringMatchCaseInsensitive:(NSString*)haystack;

-(BOOL)isStringMatchCaseInsensitive:(NSString*)haystack regExPattern:(NSString*)regExPattern;

-(id)initWithPattern:(NSString*)regExPattern;

-(BOOL)isFileMatchCaseInsensitive:(AGEDFile*)file;

-(BOOL)isFileMatchCaseInsensitive:(AGEDFile*)file regExPattern:(NSString*)regExPattern;

@end
