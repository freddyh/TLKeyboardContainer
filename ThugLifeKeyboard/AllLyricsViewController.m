//
//  AllLyricsViewController.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 1/10/16.
//  Copyright © 2016 FredHedz. All rights reserved.
//

#import "AllLyricsViewController.h"
#import "LyricsManager.h"
#import "ThugLifeLyrics.h"
#import "CategoryPicker.h"


@interface AllLyricsViewController ()<UITableViewDataSource, UITableViewDelegate, CategoryPickerDelegate>

@property NSArray *lyricData;

@property (weak, nonatomic) IBOutlet UITableView *allLyricsTableView;
@property (strong, nonatomic) CategoryPicker *categoryPicker;
@property (nonatomic) BOOL isCategoryPickerVisible;
@property (weak, nonatomic) IBOutlet UIButton *categoryPickerButton;

@end

@implementation AllLyricsViewController

- (IBAction)showNextKeyboard:(UIButton *)sender {
	
	[_delegate lyricsViewShouldShowNextKeyboard];
}

- (IBAction)categoryPickerButtonTapped:(UIButton *)sender {
	
	if (!_isCategoryPickerVisible) {
		[_categoryPicker showCategoryPicker:true];
	} else {
		[_categoryPicker showCategoryPicker:false];
	}
}

- (IBAction)backspaceButtonTapped:(UIButton *)sender {
	
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [_lyricData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/***
	 Create a reusable cell if one does not exist
	 ***/
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LyricCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LyricCell"];
	}
	
	ThugLifeLyrics *song = [_lyricData objectAtIndex:[indexPath row]];
	[[cell textLabel] setText:[song lyric]];
	[[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
	[[cell textLabel] setNumberOfLines:0];
	return cell;
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64;
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/***
	 Send the lyric to the KeyboardViewController
	 (Considering not sending the index with the lyric)
	 ***/
	
	NSUInteger index = [indexPath row];
	ThugLifeLyrics *songLyric = [_lyricData objectAtIndex:index];
	songLyric.usedCount += 1;
	NSString *lyric = [songLyric lyric];
	[_delegate lyricsViewDidSelectItem:lyric AtIndex:index];
	
}

-(void)loadTableView {
	
	_lyricData = [[LyricsManager sharedManager] fetchForCategory:_currentCategory];
	[_allLyricsTableView reloadData];
}

#pragma mark CategoryPickerDelegate Methods

- (void)categoryPickerDidSelectCategoryWithName:(NSString *)categoryName {
	
	_currentCategory = categoryName;
	[self loadTableView];
	[_categoryPicker showCategoryPicker:false];
}

- (void)categoryPickerWillClose {
	_isCategoryPickerVisible = false;
	NSString *currentTitle = _currentCategory == nil ? @"All Categories" : _currentCategory;
	[_categoryPickerButton setTitle:currentTitle forState:UIControlStateNormal];
}

- (void)categoryPickerWillOpen {
	_isCategoryPickerVisible = true;
}

@end
