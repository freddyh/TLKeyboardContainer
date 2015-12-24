//
//  ThugLifeCategoryTableViewController.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import "ThugLifeCategoryTableViewController.h"

@interface ThugLifeCategoryTableViewController ()

@property NSUInteger selectedIndex;

@end

@implementation ThugLifeCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	/***
	 If there is a _selectedCategoryName, then set the index.
	 ***/
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
	 Otherwise, remove any checkmarks from the reusable cell
	 ***/
	if (_selectedCategoryName != nil && _selectedIndex == [indexPath row]) {
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
	
	/***
	 Pass the category name to the CategoryPicker
	 ***/
	[_delegate thugLifeCategoryTableViewControllerDidSelectItem:_selectedCategoryName];
}

- (void)configureSelectedIndex:(NSUInteger)index {
	
	/***
	 Check if the row matches the _selectedIndex
	 ***/
	if (_selectedIndex == index) {
		_selectedCategoryName = nil;
	} else {
		_selectedIndex = index;
		_selectedCategoryName = [_tableData objectAtIndex: _selectedIndex];
	}
}

@end
