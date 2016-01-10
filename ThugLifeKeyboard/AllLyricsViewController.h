//
//  AllLyricsViewController.h
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 1/10/16.
//  Copyright © 2016 FredHedz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllLyricsViewDelegate <NSObject>

- (void)lyricsViewDidSelectItem:(NSString *)item AtIndex:(NSUInteger)index;
- (void)lyricsViewShouldShowNextKeyboard;

@end

@interface AllLyricsViewController : UIViewController

@property (weak) id <AllLyricsViewDelegate>delegate;
@property NSString *currentCategory;

@end
