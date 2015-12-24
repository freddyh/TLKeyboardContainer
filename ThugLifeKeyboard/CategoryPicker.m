//
//  CategoryPicker.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import "CategoryPicker.h"
#import "ThugLifeCategoryTableViewController.h"
#import "LyricsManager.h"

@interface CategoryPicker() <ThugLifeCategoryTableViewControllerDelegate>

@property (weak) UIView *originView;
@property UIView *containerView;
@property ThugLifeCategoryTableViewController *thugLifeCategoryTableViewController;

@end


@implementation CategoryPicker

-(id)initWithSourceView:(UIView *)sourceView andData:(NSArray *)menuItems {
	self = [super init];
	
	_originView = sourceView;
	[self setupTableView];
	
	_thugLifeCategoryTableViewController.tableData = menuItems;
	
	return self;
}

- (void)setupTableView {
	
	/***
	 Add _containerView to view hierarchy
	 Reduce the height to save space for the toolbar of the keyboard
	 ***/
	_containerView = [[UIView alloc] initWithFrame:CGRectMake(0, _originView.frame.size.height, _originView.frame.size.width, _originView.frame.size.height - 40.0)];
	[_originView addSubview:_containerView];
	
	
	/***
	 Create a TableViewController that fills the _containerView, has no cell separators, and custom blue background color
	 Data Source comes from LyricsManager
	 Default selectedCategoryName is nil
	 ***/
	_thugLifeCategoryTableViewController = [ThugLifeCategoryTableViewController new];
	_thugLifeCategoryTableViewController.selectedCategoryName = nil;
	[_thugLifeCategoryTableViewController setDelegate:self];
	[_thugLifeCategoryTableViewController.tableView setFrame:_containerView.bounds];
	[_thugLifeCategoryTableViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_thugLifeCategoryTableViewController.tableView setScrollsToTop:false];
	[_thugLifeCategoryTableViewController.tableView setBackgroundColor:[UIColor colorWithRed:47.0/255.0 green:102.0/255.0 blue:174.0/255.0 alpha:1.0]];
	[_containerView addSubview:_thugLifeCategoryTableViewController.tableView];
}

- (void)showCategoryPicker:(BOOL)shouldOpen {
	
	
	/***
	 The CategoryPicker will animate to the top of _originView or off the bottom of the screen
	 ***/
	if (shouldOpen) {
		[_delegate categoryPickerWillOpen];
		[UIView animateWithDuration:0.2 animations:^{
			
			[_containerView setFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.origin.y, _originView.frame.size.width, _originView.frame.size.height - 40.0)];
		}];
	} else {
		[_delegate categoryPickerWillClose];
		[UIView animateWithDuration:0.2 animations:^{
			
			[_containerView setFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.size.height, _originView.frame.size.width, _originView.frame.size.height - 40.0)];
		}];
	}
}

- (void) thugLifeCategoryTableViewControllerDidSelectItem:(NSString *)categoryName {
	
	[_delegate categoryPickerDidSelectItemAtIndex:categoryName];
	[[_thugLifeCategoryTableViewController tableView] reloadData];
}

@end
