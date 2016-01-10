//
//  ThugLifeLyrics.h
//  ThugLife
//
//  Created by fredhedz on 3/19/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThugLifeLyrics : NSObject

@property (nonatomic, strong) NSString *lyric;
@property (nonatomic, strong) NSString *songTitle;
@property (nonatomic, strong) NSString *albumTitle;
@property (nonatomic, strong) NSString *thugLifeTrackId;
@property (nonatomic, strong) NSString *lyricCategory;
@property (nonatomic) NSUInteger usedCount;

@end
