//
//  CategoryPickerViewController.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 1/10/16.
//  Copyright © 2016 FredHedz. All rights reserved.
//

#import "CategoryPickerViewController.h"

@interface CategoryPickerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property NSInteger selectedIndex;

@end

@implementation CategoryPickerViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_selectedIndex = _selectedCategoryName == nil ? -1 : [_categoryData indexOfObject:_selectedCategoryName];
	[_categoryTableView reloadData];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [_categoryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/***
	 Create a reusable cell if one does not exist
	 ***/
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryCell"];
	}
	
	cell.textLabel.text = [_categoryData objectAtIndex:[indexPath row]];
	
	if (_selectedIndex == [indexPath row]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[tableView deselectRowAtIndexPath:indexPath animated:true];
	
	[self configureSelectedIndex:[indexPath row]];
	[_delegate categoryPickerDidSelectItemAtIndex:_selectedIndex];
	
	/***
	 Toggle the checkmark
	 ***/
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = (cell.accessoryType != UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

}

- (void)configureSelectedIndex:(NSInteger)index {
	
	/***
	 Check if the row matches the _selectedIndex
	 ***/
	if (_selectedIndex == index) {
		_selectedCategoryName = nil;
		_selectedIndex = -1;
	} else {
		_selectedIndex = index;
	}
}

@end
