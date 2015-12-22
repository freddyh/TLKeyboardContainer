//
//  KeyboardViewController.m
//  ThugLifeKeyboard
//
//  Created by fredhedz on 6/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "KeyboardViewController.h"
#import "ThugLifeLyricTableViewCell.h"
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
    
    // Add custom view sizing constraints here
}

- (IBAction)nextKeyboard:(id)sender {
    
    [self advanceToNextInputMode];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isCategoryPickerVisible = NO;
    
    UINib *nib = [UINib nibWithNibName:@"ThugLifeKeyboardView" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:self options:nil];
    self.view = arr[0];
    
    [self.lyricsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.lyricsTableView setRestorationIdentifier:@"ThugLifeLyricsTable"];
    [self.lyricsTableView setDelegate:self];
    [self.lyricsTableView setDataSource:self];
    [self.lyricsTableView setEstimatedRowHeight:44];
    [self.lyricsTableView setRowHeight:UITableViewAutomaticDimension];
	
	CategoryPicker *bottomBarCategoryPicker = [[CategoryPicker alloc] initWithSourceView:self.view andData:[LyricsManager sharedManager].allCategories];
	bottomBarCategoryPicker.delegate = self;
    self.categoryPicker = bottomBarCategoryPicker;
    
}

- (IBAction)categoryPickerButtonTapped:(id)sender {
    //If toolbar is expanded then update lyrics according to category and remove tableview for categories
    //If toolbar is not expanded then add tableview to subview
	
	
    if (!_isCategoryPickerVisible) {
		[_categoryPicker showCategoryPicker:true];
		_isCategoryPickerVisible = true;
        
    } else {
		[_categoryPicker showCategoryPicker:false];
        _isCategoryPickerVisible = NO;
        if (self.currentCategory) {
            [self.lyricsTableView reloadData];
        }
        
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
	}
    NSArray *lyricsArray = [[LyricsManager sharedManager] fetchForCategory:_currentCategory];
	ThugLifeLyrics *song = [lyricsArray objectAtIndex:indexPath.row];
	cell.textLabel.text = song.lyric;
	return cell;
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[self.textDocumentProxy insertText:cell.textLabel.text];
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
	_currentCategory = allCategories[index];
	[_lyricsTableView reloadData];
}

- (void)categoryPickerWillClose {
	
}

- (void)categoryPickerWillOpen {
	
}

@end
