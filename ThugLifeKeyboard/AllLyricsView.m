//
//  AllLyricsView.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import "AllLyricsView.h"
#import "LyricsManager.h"
#import "ThugLifeLyrics.h"
#import "CategoryPicker.h"

static const CGFloat buttonSize = 40.0;

@interface AllLyricsView() <UITableViewDataSource, UITableViewDelegate, CategoryPickerDelegate>

@property (weak) UIView *originView;
@property (strong, nonatomic)UIView *containerView;
@property (strong, nonatomic)UITableView *thugLifeLyricsTableView;
@property NSArray *lyricData;
@property (strong, nonatomic) CategoryPicker *categoryPicker;
@property (nonatomic) BOOL isCategoryPickerVisible;
@property (strong, nonatomic)UIButton *nextKeyboardButton;
@property (strong, nonatomic)UIButton *pickCategoryButton;

@end

@implementation AllLyricsView

-(id)initWithSourceView:(UIView *)sourceView {
	self = [super init];
	
	_originView = sourceView;
	
	/***
	 Create _containerView and add it to view hierarchy
	 ***/
	_containerView = [[UIView alloc] initWithFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.origin.y, _originView.frame.size.width, _originView.frame.size.height - buttonSize)];
	[_originView addSubview:_containerView];
	
	[self setupLyricsTableView];
	[self setupCategoryPicker];
	[self setupCategoryPickerButton];
	[self setupNextKeyboardButton];
	
	return self;
}

-(void)setupLyricsTableView {

	/***
	 Create TableView, add it to view hierarchy, assign self as Delegate and DataSource
	 DataSource comes from LyricsManager
	 ***/
	_thugLifeLyricsTableView = [[UITableView alloc] initWithFrame:_containerView.frame style:UITableViewStylePlain];
	[_thugLifeLyricsTableView setDelegate:self];
	[_thugLifeLyricsTableView setDataSource:self];
	[_thugLifeLyricsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LyricCell"];
	[_containerView addSubview:_thugLifeLyricsTableView];
	[self loadTableView];
}

-(void)setupCategoryPicker {
	
	_categoryPicker = [[CategoryPicker alloc] initWithSourceView:_containerView andData:[[LyricsManager sharedManager] allCategories]];
	_categoryPicker.selectedCategoryName = _currentCategory;
	[_categoryPicker setDelegate:self];
	_isCategoryPickerVisible = NO;
}

-(void)setupCategoryPickerButton {
	_pickCategoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _originView.bounds.size.height - buttonSize, _originView.bounds.size.width, buttonSize)];
	[_pickCategoryButton addTarget:self action:@selector(pickCategoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[_pickCategoryButton setTitle:@"Select A Category" forState:UIControlStateNormal];
	[_pickCategoryButton setBackgroundColor:[UIColor colorWithRed:47.0/255.0 green:102.0/255.0 blue:174.0/255.0 alpha:1.0]];
	[_originView addSubview:_pickCategoryButton];
}

-(void)setupNextKeyboardButton {
	
	_nextKeyboardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _originView.bounds.size.height - buttonSize, buttonSize, buttonSize)];
	[_nextKeyboardButton addTarget:self action:@selector(nextKeyboardButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[_nextKeyboardButton setImage:[UIImage imageNamed:@"globe-button.png"] forState:UIControlStateNormal];
	[_originView addSubview:_nextKeyboardButton];
}

-(void)pickCategoryButtonTapped {
	
	if (!_isCategoryPickerVisible) {
		[_categoryPicker showCategoryPicker:true];
	} else {
		[_categoryPicker showCategoryPicker:false];
	}
}

- (void)nextKeyboardButtonTapped {

	[_delegate lyricsViewShouldShowNextKeyboard];
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
	[_thugLifeLyricsTableView reloadData];
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
	[_pickCategoryButton setTitle:currentTitle forState:UIControlStateNormal];
}

- (void)categoryPickerWillOpen {
	_isCategoryPickerVisible = true;
}

@end
