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

@interface AllLyricsView() <UITableViewDataSource, UITableViewDelegate>

@property (weak) UIView *originView;
@property UIView *containerView;
@property UITableView *thugLifeLyricsTableView;
@property NSArray *lyricData;

@end

@implementation AllLyricsView

-(id)initWithSourceView:(UIView *)sourceView {
	self = [super init];
	
	_originView = sourceView;
	
	/***
	 Create _containerView and add it to view hierarchy
	 (Again, 44 is the space for the keyboard toolbar. There must be a better way to do this.)
	 ***/
	_containerView = [[UIView alloc] initWithFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.origin.y, _originView.frame.size.width, _originView.frame.size.height - 44.0)];
	[_originView addSubview:_containerView];
	
	/***
	 Create TableView, add it to view hierarchy, assign self as Delegate and DataSource
	 DataSource comes from LyricsManager
	 ***/
	_thugLifeLyricsTableView = [[UITableView alloc] initWithFrame:_containerView.frame style:UITableViewStylePlain];
	[_thugLifeLyricsTableView setDelegate:self];
	[_thugLifeLyricsTableView setDataSource:self];
	[_thugLifeLyricsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LyricCell"];
	[_containerView addSubview:_thugLifeLyricsTableView];
	
	_lyricData = [[LyricsManager sharedManager] fetchForCategory:_currentCategory];
	
	return self;
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
	 (Consider not sending the index with the lyric)
	 ***/
	NSUInteger index = [indexPath row];
	NSString *lyric = [[_lyricData objectAtIndex:index] lyric];
	[_delegate lyricsViewDidSelectItem:lyric AtIndex:index];
	
	//increase useCount
	//If useCount is greater than zero, then add to recently used category? not here? in LyricsManager?
}

-(void)loadTableView {
	
	_lyricData = [[LyricsManager sharedManager] fetchForCategory:_currentCategory];
	[_thugLifeLyricsTableView reloadData];
}

@end
