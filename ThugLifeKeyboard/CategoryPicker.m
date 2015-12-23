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
	
	return self;
}

- (void)setupCategoryPicker {
	
	_containerView = [[UIView alloc] initWithFrame:CGRectMake(0, _originView.frame.size.height, _originView.frame.size.width, _originView.frame.size.height - 44.0)];
	
	[_originView addSubview:_containerView];
	_thugLifeCategoryTableViewController = [ThugLifeCategoryTableViewController new];
	[_thugLifeCategoryTableViewController setDelegate:self];
	[_thugLifeCategoryTableViewController.tableView setFrame:_containerView.bounds];
	[_thugLifeCategoryTableViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_thugLifeCategoryTableViewController.tableView setScrollsToTop:false];
	[_thugLifeCategoryTableViewController.tableView setBackgroundColor:[UIColor colorWithRed:47.0/255.0 green:102.0/255.0 blue:174.0/255.0 alpha:1.0]];
	
	[_containerView addSubview:_thugLifeCategoryTableViewController.tableView];
}

- (void)showCategoryPicker:(BOOL)shouldOpen {
	
	if (shouldOpen) {
		[_delegate categoryPickerWillOpen];
		[UIView animateWithDuration:0.2 animations:^{
			
			[_containerView setFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.origin.y, _originView.frame.size.width, _originView.frame.size.height - 44.0)];
		}];
	} else {
		[_delegate categoryPickerWillClose];
		[UIView animateWithDuration:0.2 animations:^{
			
			[_containerView setFrame:CGRectMake(_originView.frame.origin.x, _originView.frame.size.height, _originView.frame.size.width, _originView.frame.size.height - 44.0)];
		}];
	}
}

- (void) thugLifeCategoryTableViewControllerDidSelectItem:(NSString *)categoryName {
	
	[_delegate categoryPickerDidSelectItemAtIndex:categoryName];
	[[_thugLifeCategoryTableViewController tableView] reloadData];
}

@end
