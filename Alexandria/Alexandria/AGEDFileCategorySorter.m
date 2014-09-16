//
//  AGEDFileCategorySorter.m
//  Alexandria
//
//  Created by Allen Xavier on 7/23/14.
//  Copyright (c) 2014 ___ALLENGARVEY___. All rights reserved.
//

#import "AGEDFileCategorySorter.h"

@interface AGEDFileCategorySorter()

@property (nonatomic) NSInteger categoryTitlesAndPatternsLength;
@property (strong, nonatomic) AGEDRegExMatcher* matcher;

@end

@implementation AGEDFileCategorySorter

-(id)init
{
	self = [super init];
	
	if(self){
		[self setDefaults];
		_matcher = [AGEDRegExMatcher new];
	}
	
	return self;
}

-(void)setTestDefaults
{
	_categoryTitlesAndPatterns = @[
				  @"Fitness",					@"bodybuild|muscle|fitness|excercise|diet|strength|conditioning|ball|stretch|pavel|\\beat\\b",
				  @"Graphic Design",			@"graphic|typography|photoshop|illustrator|adobe",
				  @"Music",						@"music|reason[0-9]*",
				  @"XML",						@"xml",
				  @"Math",						@"calculus|algebra|math",
				  @"Economics",					@"economics",
				  @"Business",					@"money|^earn|\\$",
				  @"Biography",					@"biography",
				  @"Pickup",					@"women|red.pill|sex|roosh|charisma|attract",
				  @"Python",					@"python|django",
				  @"Java",						@"java |j2ee",
				  @"Objective-C",				@"objective.c|ios[0-9]*|cocoa",
				  @"C",							@"[^0-9a-z]c[^0-9a-z]|^c[^0-9a-z]|[^0-9a-z]c$",
				  @"Web Design",				@"html|css|javascript|php|rails|jquery|internet|web|cold.fusion",
				  @"Databases",					@"database|sql",
				  @"Operating Systems",			@"operating.system[s]?",
				  @"Software Engineering",		@"software.engineering|software",
				  @"Pyschology",				@"pyschology|anxiety",
				  @"Science",					@"physics|chemistry|experiment|[^computer ]science",
				  @"Self-Improvement",			@"self.improve|wisdom|mastery",
				  @"Photography",				@"photography",
				  @"Art",						@"\\bart\\b|\\bartist(s)?\\b|banksy",
				  @"Spirituality",				@"spirituality|\\bgod\\b|[^0-9a-z]god[^0-9a-z]|^god[^0-9a-z]",
				  @"Computer Programming",		@"program|computer|algorithm|regular.expression"
				  ];
	_categoryTitlesAndPatternsLength = [_categoryTitlesAndPatterns count];
}

-(void)setDefaults
{
	_categoryTitlesAndPatterns = @[];
	_categoryTitlesAndPatternsLength = [_categoryTitlesAndPatterns count];
}

-(void)setCategoryTitlesAndPatterns:(NSArray *)categoryTitlesAndPatterns
{
	_categoryTitlesAndPatterns = categoryTitlesAndPatterns;
	_categoryTitlesAndPatternsLength = [_categoryTitlesAndPatterns count];
}

-(NSString*)matchCategory:(NSString*)stringToBeMatched
{
	stringToBeMatched = [stringToBeMatched stringByDeletingPathExtension];
	NSString *category = @"";
	
	for (int i=1; i<=_categoryTitlesAndPatternsLength; i+=2) {
		if ([_matcher isStringMatchCaseInsensitive:stringToBeMatched regExPattern:_categoryTitlesAndPatterns[i]]) {
			category = _categoryTitlesAndPatterns[i-1];
			break;
		}
	}
	
	return category;
}

-(NSString*)fileCategory:(AGEDFile *)file
{
	NSString *fileCategory = @"";
	
	if ([file filename]) {
		fileCategory = [self matchCategory:[file filename]];
	}

	if ([fileCategory isEqualToString:@""]) {
		//		try to match category based on folder the file is in if can't match based on filename
		if ([file directory]) {
			fileCategory = [self matchCategory:[[file directory] lastPathComponent]];
		}
	}
	
	return fileCategory;
}


@end
