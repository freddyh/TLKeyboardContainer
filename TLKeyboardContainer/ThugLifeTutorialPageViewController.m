//
//  ThugLifeTutorialPageViewController.m
//  TLKeyboardContainer
//
//  Created by fredhedz on 6/26/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "ThugLifeTutorialPageViewController.h"

@interface ThugLifeTutorialPageViewController ()

@property (strong, nonatomic) IBOutlet UILabel *tutorialTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thugLifeImageView;

@end

@implementation ThugLifeTutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    self.tutorialTitleLabel.text = self.thugLifeTitle;
    self.thugLifeImageView.image = [UIImage imageNamed:self.imageName];
}

- (void)viewDidAppear:(BOOL)animated {

}
@end
