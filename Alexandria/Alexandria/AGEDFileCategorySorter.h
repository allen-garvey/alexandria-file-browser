//
//  AGEDFileCategorySorter.h
//  Alexandria
//
//  Created by Allen Xavier on 7/23/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGEDFileCategorySorter : NSObject

@property (strong, nonatomic) NSArray* categoryTitlesAndPatterns;

-(NSString*)fileCategory:(AGEDFile*)file;

@end
