//
//  KeyboardViewController.m
//  ThugLifeKeyboard
//
//  Created by fredhedz on 6/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "KeyboardViewController.h"
#import "AllLyricsViewController.h"

@interface KeyboardViewController ()<AllLyricsViewDelegate>

@property (strong, nonatomic) AllLyricsViewController *allLyricsViewController;

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
	_allLyricsViewController = [AllLyricsViewController new];
	[_allLyricsViewController setDelegate:self];
	[self presentViewController:_allLyricsViewController animated:false completion:nil];
}

#pragma mark UITextInputDelegate Methods

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
}

#pragma mark AllLyricsViewDelegate Methods

- (void)lyricsViewDidSelectItem:(NSString *)item AtIndex:(NSUInteger)index {
	
	[[self textDocumentProxy] insertText:item];
}

- (void)shouldShowNextKeyboard {
	[self advanceToNextInputMode];
}

- (void)shouldDeleteBackwards {
	[[self textDocumentProxy] deleteBackward];
}

@end
