//
//  KeyboardViewController.m
//  ThugLifeKeyboard
//
//  Created by fredhedz on 6/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "KeyboardViewController.h"
#import "CategoryPicker.h"

@interface KeyboardViewController ()<UITableViewDataSource, UITableViewDelegate, CategoryPickerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *nextKeyboardButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryPickerButton;
@property (strong, nonatomic) IBOutlet UITableView *lyricsTableView;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;

@property (strong, nonatomic) CategoryPicker *categoryPicker;
@property (strong, nonatomic) NSString *currentCategory;
@property (strong, nonatomic) NSArray *dataArray;

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
    
    [self.lyricsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.lyricsTableView setDelegate:self];
    [self.lyricsTableView setDataSource:self];
	
	CategoryPicker *bottomBarCategoryPicker = [[CategoryPicker alloc] initWithSourceView:[self view] andData:[[LyricsManager sharedManager] allCategories]];
	[bottomBarCategoryPicker setDelegate:self];
    _categoryPicker = bottomBarCategoryPicker;
	_isCategoryPickerVisible = NO;
}

- (IBAction)categoryPickerButtonTapped:(id)sender {
	
    if (!_isCategoryPickerVisible) {
		[_categoryPicker showCategoryPicker:true];
    } else {
		[_categoryPicker showCategoryPicker:false];
    }
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
    return [[[LyricsManager sharedManager] fetchForCategory:_currentCategory] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
		[[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
		[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
		[[cell textLabel] setNumberOfLines:0];
	}
	
    NSArray *lyricsArray = [[LyricsManager sharedManager] fetchForCategory:_currentCategory];
	ThugLifeLyrics *song = [lyricsArray objectAtIndex:[indexPath row]];
	[[cell textLabel] setText:[song lyric]];
	return cell;
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[self.textDocumentProxy insertText:[[cell textLabel] text]];
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

- (void)categoryPickerDidSelectItemAtIndex:(int)index {
	NSArray *allCategories = [[LyricsManager sharedManager] allCategories];
	_currentCategory = [allCategories objectAtIndex:index];
	[_lyricsTableView reloadData];
	[_categoryPicker showCategoryPicker:false];
}

- (void)categoryPickerWillClose {
	_isCategoryPickerVisible = false;
	[_lyricsTableView reloadData];
	[_categoryPickerButton setTitle:_currentCategory forState:UIControlStateNormal];
}

- (void)categoryPickerWillOpen {
	_isCategoryPickerVisible = true;
}

@end
