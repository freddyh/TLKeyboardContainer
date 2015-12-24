//
//  KeyboardViewController.m
//  ThugLifeKeyboard
//
//  Created by fredhedz on 6/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "KeyboardViewController.h"
#import "AllLyricsView.h"

@interface KeyboardViewController ()<AllLyricsViewDelegate>

@property (strong, nonatomic) AllLyricsView *allLyricsView;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	/***
	 Create object for displaying all lyrics
	 ***/
	[self setupAllLyricsView];

}

- (void)setupAllLyricsView {
	
	_allLyricsView = [[AllLyricsView alloc] initWithSourceView: [self view]];
	[_allLyricsView setDelegate:self];
}

#pragma mark UITextInputDelegate Methods

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
//    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

#pragma mark AllLyricsViewDelegate Methods

- (void)lyricsViewDidSelectItem:(NSString *)item AtIndex:(NSUInteger)index {
	
	[[self textDocumentProxy] insertText:item];
}

- (void)lyricsViewShouldShowNextKeyboard {
	[self advanceToNextInputMode];
}

@end
