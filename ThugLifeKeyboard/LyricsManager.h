//
//  LyricsManager.h
//  ThugLife
//
//  Created by fredhedz on 3/19/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThugLifeLyrics.h"

@interface LyricsManager : NSObject

+ (instancetype)sharedManager;

- (NSArray *)allLyrics;
- (NSArray *)allCategories;
- (NSArray *)fetchForCategory:(NSString *)name;

@end
