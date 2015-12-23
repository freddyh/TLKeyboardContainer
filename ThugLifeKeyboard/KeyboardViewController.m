//
//  KeyboardViewController.m
//  ThugLifeKeyboard
//
//  Created by fredhedz on 6/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "KeyboardViewController.h"
#import "CategoryPicker.h"
#import "AllLyricsView.h"

@interface KeyboardViewController ()<CategoryPickerDelegate, AllLyricsViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *nextKeyboardButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryPickerButton;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;

@property (strong, nonatomic) UITableView *lyricsTableView;
@property (strong, nonatomic) CategoryPicker *categoryPicker;
@property (strong, nonatomic) NSArray *categoryData;
@property (strong, nonatomic) AllLyricsView *allLyricsView;
@property (strong, nonatomic) NSString *currentCategory;

@property (nonatomic) BOOL isCategoryPickerVisible;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (IBAction)nextKeyboard:(id)sender {
    
    [self advanceToNextInputMode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ThugLifeKeyboardView" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:self options:nil];
    self.view = arr[0];
	
	[self setupTableView];
	[self setupCategoryPicker];
}

- (IBAction)categoryPickerButtonTapped:(id)sender {
	
    if (!_isCategoryPickerVisible) {
		[_categoryPicker showCategoryPicker:true];
    } else {
		[_categoryPicker showCategoryPicker:false];
    }
}

- (void)setupTableView {
	
	_allLyricsView = [[AllLyricsView alloc] initWithSourceView: [self view]];
	[_allLyricsView setDelegate:self];
	
}

- (void)setupCategoryPicker {
	
	_categoryData = [[LyricsManager sharedManager] allCategories];
	CategoryPicker *bottomBarCategoryPicker = [[CategoryPicker alloc] initWithSourceView:[self view] andData:_categoryData];
	[bottomBarCategoryPicker setDelegate:self];
	_categoryPicker = bottomBarCategoryPicker;
	_isCategoryPickerVisible = NO;
}

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
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

#pragma mark CategoryPickerDelegate Methods

- (void)categoryPickerDidSelectItemAtIndex:(NSString *)categoryName {

	_currentCategory = categoryName == nil ? @"No Category Selected" : categoryName;
	[_categoryPicker showCategoryPicker:false];
}

- (void)categoryPickerWillClose {
	
	[_lyricsTableView reloadData];
	_isCategoryPickerVisible = false;
	[_categoryPickerButton setTitle:_currentCategory forState:UIControlStateNormal];
}

- (void)categoryPickerWillOpen {
	
	_isCategoryPickerVisible = true;
}

#pragma mark AllLyricsViewDelegate Methods

- (void)lyricsViewDidSelectItem:(NSString *)item AtIndex:(int)index {
	
	[[self textDocumentProxy] insertText:item];
}

@end
