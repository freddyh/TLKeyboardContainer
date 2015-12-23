//
//  ThugLifeCategoryTableViewController.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import "ThugLifeCategoryTableViewController.h"
#import "LyricsManager.h"

@interface ThugLifeCategoryTableViewController ()

@property NSUInteger selectedIndex;
@property NSArray *tableData;

@end

@implementation ThugLifeCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_tableData = [[LyricsManager sharedManager] allCategories];
	if (_selectedCategoryName != nil) {
		_selectedIndex = [_tableData indexOfObject:_selectedCategoryName];
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryCell"];
	}
	
	cell.textLabel.text = [_tableData objectAtIndex:[indexPath row]];
	
	
	if (_selectedCategoryName != nil && _selectedIndex == [indexPath row]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if (_selectedIndex == [indexPath row]) {
		_selectedCategoryName = nil;
	} else {
		_selectedIndex = [indexPath row];
		_selectedCategoryName = [_tableData objectAtIndex: _selectedIndex];
	}
	
	cell.accessoryType = (cell.accessoryType != UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
	[tableView deselectRowAtIndexPath:indexPath animated:false];
	[_delegate thugLifeCategoryTableViewControllerDidSelectItem:_selectedCategoryName];
}

@end
