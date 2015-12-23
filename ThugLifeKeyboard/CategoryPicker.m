//
//  CategoryPicker.m
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import "CategoryPicker.h"
#import "ThugLifeCategoryTableViewController.h"

@interface CategoryPicker() <ThugLifeCategoryTableViewControllerDelegate>

@property (weak) UIView *originView;
@property UIView *containerView;
@property ThugLifeCategoryTableViewController *thugLifeCategoryTableViewController;

@end


@implementation CategoryPicker

-(id)initWithSourceView:(UIView *)sourceView andData:(NSArray *)menuItems {
	self = [super init];
	
	_originView = sourceView;
	[self setupCategoryPicker];
	_thugLifeCategoryTableViewController.tableData = menuItems;
	
	
	return self;
}

- (void)setupCategoryPicker {
	
	CGRect containerRect = _originView.frame;
	containerRect.origin.y = _originView.frame.size.height;
	containerRect.size.height = _originView.frame.size.height - 44.0;
	_containerView = [[UIView alloc] initWithFrame:containerRect];
	
	[_originView addSubview:_containerView];
	_thugLifeCategoryTableViewController = [ThugLifeCategoryTableViewController new];
	[_thugLifeCategoryTableViewController setDelegate:self];
	[_thugLifeCategoryTableViewController.tableView setFrame:_containerView.bounds];
	[_thugLifeCategoryTableViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_thugLifeCategoryTableViewController.tableView setScrollsToTop:false];
	[_thugLifeCategoryTableViewController.tableView setBackgroundColor:[UIColor colorWithRed:47.0/255.0 green:102.0/255.0 blue:174.0/255.0 alpha:1.0]];
	[_thugLifeCategoryTableViewController.tableView reloadData];
	
	[_containerView addSubview:_thugLifeCategoryTableViewController.tableView];
}

- (void)showCategoryPicker:(BOOL)shouldOpen {
	
	if (shouldOpen) {
		[_delegate categoryPickerWillOpen];
		[UIView animateWithDuration:0.2 animations:^{
			CGRect containerRect = _originView.frame;
			//containerRect.origin.y = _originView.frame.size.height;
			containerRect.size.height = _originView.frame.size.height - 44.0;
			[_containerView setFrame:containerRect];
		}];
	} else {
		[_delegate categoryPickerWillClose];
		[UIView animateWithDuration:0.2 animations:^{
			CGRect newRect = _originView.frame;
			newRect.origin.y = _originView.frame.size.height;
			newRect.size.height = _originView.frame.size.height - 44.0;
			[_containerView setFrame:newRect];
		}];
	}
}

- (void) thugLifeCategoryTableViewControllerDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_delegate categoryPickerDidSelectItemAtIndex:indexPath.row];
}

@end
