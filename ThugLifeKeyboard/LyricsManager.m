//
//  LyricsManager.m
//  ThugLife
//
//  Created by fredhedz on 3/19/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "LyricsManager.h"

@interface LyricsManager ()

@property (nonatomic, strong) NSMutableArray *lyricsArray;

@end

@implementation LyricsManager

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        [self loadLyrics];
    }
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[LyricsManager sharedManager]"
                                 userInfo:nil];
    return nil;
    
}

+ (instancetype)sharedManager
{
    static LyricsManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initPrivate];
    });
    
    return sharedManager;
}

- (NSArray *)allLyrics
{
    return _lyricsArray;
}

- (void)loadLyrics
{
    _lyricsArray = [NSMutableArray new];
    NSArray *lyricsArray = [self lyricsFromFile];
    
    //Start at 1 to skip the column titles
    for (int i = 1; i < [lyricsArray count]; i++) {
        NSArray *lyricDetails = [[lyricsArray objectAtIndex:i] componentsSeparatedByString:@"\t"];
        ThugLifeLyrics *newLyric = [ThugLifeLyrics new];
        
        //Remove quotation marks
        NSString *removedQuotesString = [lyricDetails[0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        newLyric.lyric = removedQuotesString;
        
        
        newLyric.lyricCategory = lyricDetails[1];
        newLyric.songTitle = lyricDetails[2];
        newLyric.albumTitle = lyricDetails[3];
        
        newLyric.usedCount = 0;

        [_lyricsArray addObject:newLyric];
    }
}

- (NSArray *)lyricsFromFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tupac_lyrics"] ofType:@".txt"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString *fileContents = [[NSString alloc] initWithBytes:[fileData bytes] length:[fileData length] encoding:NSUTF16StringEncoding];
    return [fileContents componentsSeparatedByString:@"\n"];
}

- (NSArray *)fetchForCategory:(NSString *)name
{
	//If no category name is provided then return all lyrics
    if (name == nil) {
        return _lyricsArray;
    }
    
    NSMutableArray *result = [NSMutableArray new];
	
	if ([name  isEqual: @"Recently Used"]) {

		for (ThugLifeLyrics *song in _lyricsArray) {
			if (song.usedCount > 0) {
				[result addObject:song];
			}
		}
	} else {
		
		for (ThugLifeLyrics *song in _lyricsArray) {
			NSString *currentType = song.lyricCategory;
			if ([currentType isEqualToString:name]) {
				[result addObject:song];
			}
		}
	}
	
	return result;
}

- (NSArray *)allCategories
{
    return @[@"Thug Life", @"Love Life", @"The Game", @"The Hood", @"Hard Knock Life", @"Recently Used"];
}

@end
