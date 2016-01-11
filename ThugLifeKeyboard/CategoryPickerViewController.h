//
//  CategoryPickerViewController.h
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 1/10/16.
//  Copyright © 2016 FredHedz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryPickerDelegate <NSObject>

- (void)categoryPickerDidSelectItemAtIndex:(NSInteger)index;

@end

@interface CategoryPickerViewController : UIViewController

@property (strong, nonatomic)NSArray *categoryData;

@property (weak) id <CategoryPickerDelegate> delegate;
@property (strong, nonatomic)NSString *selectedCategoryName;

@end
