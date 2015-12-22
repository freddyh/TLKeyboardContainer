//
//  CategoryPicker.h
//  TLKeyboardContainer
//
//  Created by Freddy Hernandez on 12/22/15.
//  Copyright © 2015 FredHedz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CategoryPickerDelegate <NSObject>

- (void)categoryPickerDidSelectItemAtIndex:(int)index;

@optional
- (void)categoryPickerWillClose;
- (void)categoryPickerWillOpen;

@end

@interface CategoryPicker : NSObject

@property (weak) id <CategoryPickerDelegate> delegate;

-(id)initWithSourceView:(UIView *)sourceView andData:(NSArray *)menuItems;

-(void)showCategoryPicker:(BOOL)shouldOpen;

@end
