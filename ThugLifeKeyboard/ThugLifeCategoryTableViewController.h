//
//  ThugLifeCategoryTableViewController.h
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThugLifeCategoryTableViewControllerDelegate <NSObject>

- (void) thugLifeCategoryTableViewControllerDidSelectItem:(NSString *)categoryName;

@end

@interface ThugLifeCategoryTableViewController : UITableViewController

@property (weak)NSArray *tableData;
@property (weak, nonatomic)NSString *selectedCategoryName;
@property (weak) id <ThugLifeCategoryTableViewControllerDelegate>delegate;

@end
