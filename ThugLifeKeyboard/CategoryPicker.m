//
//  CategoryPicker.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import "CategoryPicker.h"
#import "LyricsManager.h"

@interface CategoryPicker() <UITableViewDataSource, UITableViewDelegate>

@property (weak) UIView *originView;
@property (strong, nonatomic) UITableView *categoryTableView;
@property (strong, nonatomic) NSArray *tableData;
@property NSUInteger selectedIndex;

@end

@implementation CategoryPicker

-(id)initWithSourceView:(UIView *)sourceView andData:(NSArray *)menuItems {
	self = [super init];
	
	_originView = sourceView;
	_tableData = menuItems;
	[self setupTableView];
	
	return self;
}

- (void)setupTableView {
	
	/***
	 Create a TableViewController that fills the _originView, has no cell separators, and custom blue background color
	 Data Source comes from LyricsManager
	 Default selectedCategoryName is nil
	 ***/
	_selectedCategoryName = nil;
	_selectedIndex = -1;
	_categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _originView.bounds.size.height, _originView.bounds.size.width, _originView.bounds.size.height) style:UITableViewStylePlain];
	[_categoryTableView setDataSource:self];
	[_categoryTableView setDelegate:self];
	[_categoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_categoryTableView setScrollsToTop:false];
	[_categoryTableView setBackgroundColor:[UIColor colorWithRed:47.0/255.0 green:102.0/255.0 blue:174.0/255.0 alpha:1.0]];
	[_originView addSubview:_categoryTableView];
}

- (void)showCategoryPicker:(BOOL)shouldOpen {
	
	
	/***
	 The CategoryPicker will animate to the top of _originView or off the bottom of the screen
	 ***/
	if (shouldOpen) {
		[_delegate categoryPickerWillOpen];
		[_categoryTableView reloadData];
		[UIView animateWithDuration:0.2 animations:^{
			
			[_categoryTableView setFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.origin.y, _originView.frame.size.width, _originView.frame.size.height)];
		}];
	} else {
		[_delegate categoryPickerWillClose];
		[UIView animateWithDuration:0.2 animations:^{
			
			[_categoryTableView setFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.size.height, _originView.frame.size.width, _originView.frame.size.height)];
		}];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [_tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/***
	 Create a reusable cell if it does not exist
	 ***/
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryCell"];
	}
	[[cell textLabel] setText:[_tableData objectAtIndex:[indexPath row]]];
	
	
	/***
	 If there is a _selectedCategoryName and this is the correct row, then give the cell a checkmark.
	 Otherwise, remove any checkmarks from the cell
	 ***/
	if (_selectedIndex == [indexPath row]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:false];
	
	[self configureSelectedIndex:[indexPath row]];
	
	/***
	 Toggle the checkmark
	 ***/
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = (cell.accessoryType != UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	[_delegate categoryPickerDidSelectCategoryWithName:_selectedCategoryName];
}

- (void)configureSelectedIndex:(NSUInteger)index {
	
	/***
	 Check if the row matches the _selectedIndex
	 ***/
	if (_selectedIndex == index) {
		_selectedCategoryName = nil;
		_selectedIndex = -1;
	} else {
		_selectedIndex = index;
		_selectedCategoryName = [_tableData objectAtIndex: _selectedIndex];
	}
}

@end
