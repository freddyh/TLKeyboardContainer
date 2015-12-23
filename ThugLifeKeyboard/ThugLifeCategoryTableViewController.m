//
//  ThugLifeCategoryTableViewController.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import "ThugLifeCategoryTableViewController.h"

@interface ThugLifeCategoryTableViewController ()

@property NSIndexPath *selectedIndex;

@end

@implementation ThugLifeCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
	if (_selectedIndex != nil) {
		cell.accessoryType = indexPath.row == _selectedIndex.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	}
	
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:false];
	[_delegate thugLifeCategoryTableViewControllerDidSelectRowAtIndexPath:indexPath];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	if (_selectedIndex.row == indexPath.row && _selectedIndex != nil) {
	cell.accessoryType = UITableViewCellAccessoryNone;
	_selectedIndex = nil;
	} else {
		_selectedIndex = indexPath;
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	[tableView reloadData];
}

@end
