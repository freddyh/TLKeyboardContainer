//
//  LyricsManager.m
//  ThugLife
//
//  Created by fredhedz on 3/19/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "LyricsManager.h"
//#import "FHJImageView.h"

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
        
        
        newLyric.lyricType = lyricDetails[1];
        newLyric.songTitle = lyricDetails[2];
        newLyric.albumTitle = lyricDetails[3];
        
        NSString *imageName = [newLyric.albumTitle stringByAppendingString:@".png"];
        [newLyric setThumbnailFromImage:[UIImage imageNamed:imageName]];
        
        newLyric.savedTrack = NO;
        newLyric.usedCount = 0;
        
//        SPTSession *currentSession = [[SPTAuth defaultInstance] session];
//        NSString *spotifyQuery = [newLyric.songTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//        [SPTRequest performSearchWithQuery:spotifyQuery queryType:SPTQueryTypeTrack session:currentSession callback:^(NSError *error, SPTListPage *list) {
//            if (error) {
//                NSLog(@"Error: %@", error.description);
//            } else {
//                NSArray *items = list.items;
//                for (id obj in items) {
//                    NSString *albumName = obj[@"name"];
//                    if ([albumName isEqualToString:newLyric.albumTitle]) {
//                        
//                        //Save the track uri
//                        newLyric.spotifyURI = obj[@"uri"];
//                        
//                        //Save the first image result
//                        SPTImage *spotifyImage = obj[@"images"][0];
//                        NSURL *imageURL = spotifyImage.imageURL;
//                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                        UIImage *image = [UIImage imageWithData:imageData];
//                        newLyric.thumbnail = image;
//                    }
//                }
//            }
//            
//        }];
        

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
    if (!name) {
        return _lyricsArray;
    }
    
    NSMutableArray *result = [NSMutableArray new];
    for (ThugLifeLyrics *song in _lyricsArray) {
        NSString *currentType = song.lyricType;
        if ([currentType isEqualToString:name]) {
            [result addObject:song];
        }
    }
    
    if ([result count]) {
        return result;
    } else {
        NSLog(@"No results for category: %@", name);
        return _lyricsArray;
    }
}

- (NSArray *)allCategories
{
    return @[@"Thug Life", @"Love Life", @"The Game", @"The Hood", @"Hard Knock Life", @"Recently Used"];
}

@end
