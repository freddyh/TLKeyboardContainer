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
@property NSString *currentCategory;
@property NSArray *lyricData;

@end

@implementation AllLyricsView

-(id)initWithSourceView:(UIView *)sourceView {
	self = [super init];
	
	_originView = sourceView;
	
	_containerView = [[UIView alloc] initWithFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.origin.y, _originView.frame.size.width, _originView.frame.size.height - 44.0)];
	[_originView addSubview:_containerView];
	_thugLifeLyricsTableView = [[UITableView alloc] initWithFrame:_containerView.frame style:UITableViewStylePlain];
	[_thugLifeLyricsTableView setDelegate:self];
	[_thugLifeLyricsTableView setDataSource:self];
	[_thugLifeLyricsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LyricCell"];
	[_containerView addSubview:_thugLifeLyricsTableView];
	
	_lyricData = [[LyricsManager sharedManager] fetchForCategory:_currentCategory];
	
	return self;
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
	return [_lyricData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
	
	int row = [indexPath row];
	NSString *lyric = [[_lyricData objectAtIndex:row] lyric];
	[_delegate lyricsViewDidSelectItem:lyric AtIndex:row];
	
	
	//increase useCount
	//If useCount is greater than zero, then add to recently used category? not here
	
	//call a delegate method to inster set into textDocumentProxy
	//[self.textDocumentProxy insertText:[[cell textLabel] text]];
}

@end
