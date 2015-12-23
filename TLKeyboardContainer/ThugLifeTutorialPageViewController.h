//
//  ThugLifeTutorialPageViewController.h
//  TLKeyboardContainer
//
//  Created by fredhedz on 6/26/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import <UIKit/UIKit.h>

//A View Controller for displaying an image that demonstrates how to install the app

@interface ThugLifeTutorialPageViewController : UIViewController

@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *thugLifeTitle;
@property (strong, nonatomic) NSString *imageName;

@end
