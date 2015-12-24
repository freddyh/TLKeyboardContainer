//
//  AllLyricsView.h
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AllLyricsViewDelegate <NSObject>

- (void)lyricsViewDidSelectItem:(NSString *)item AtIndex:(NSUInteger)index;

@end

@interface AllLyricsView : NSObject

@property (weak) id <AllLyricsViewDelegate>delegate;
@property NSString *currentCategory;
-(id)initWithSourceView:(UIView *)sourceView;
-(void)loadTableView;

@end
