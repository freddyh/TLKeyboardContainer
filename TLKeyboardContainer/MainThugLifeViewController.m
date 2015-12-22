//
//  MainThugLifeViewController.m
//  TLKeyboardContainer
//
//  Created by fredhedz on 6/25/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "MainThugLifeViewController.h"
#import "ThugLifeTutorialPageViewController.h"

static NSString * const kClientId = @"8525e4ddf7ca4415919b7bb2eecbf820";
static NSString * const kCallbackURL = @"thuglife://callback";
static NSString * const kTokenSwapURL = @"http://localhost:1234/swap";

@interface MainThugLifeViewController () < MFMailComposeViewControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) NSArray *tutorialTitlesArray;
@property (strong, nonatomic) NSArray *imageTitlesArray;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation MainThugLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titlesArray = @[@"Settings >", @"General >", @"Keyboard >", @"Keyboards >", @"Add New Keyboard... >", @"Thug Life Keyboard"];
    NSArray *imageTitles = @[@"step1.png", @"step2.png", @"step3.png", @"step4.png", @"step5.png", @"step6.png"];
    self.tutorialTitlesArray = titlesArray;
    self.imageTitlesArray = imageTitles;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (IBAction)userManualButtonTapped:(id)sender {
    
    //PageView Controller with steps for installing keyboard
        
    ThugLifeTutorialPageViewController *tltController = [self viewControllerAtIndex:0];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self.pageViewController setViewControllers:@[tltController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.navigationController.navigationBarHidden = NO;
    UINavigationItem *navItem = self.pageViewController.navigationItem;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissButtonTapped:)];
    navItem.leftBarButtonItem = doneButton;
    navItem.title = self.tutorialTitlesArray[0];
    
    [self.navigationController pushViewController:self.pageViewController animated:YES];
    
}

- (IBAction)rateButtonTapped:(id)sender {
    
    //replace the link when app is added to the store
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/apple-store";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

- (IBAction)contactButtonTapped:(id)sender {
    
    //compose email with recipient and body
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [MFMailComposeViewController new];
        mailVC.mailComposeDelegate = self;
        [mailVC setToRecipients:@[@"freddhj@gmail.com"]];
        [mailVC setSubject:@"User Feedback"];
        [mailVC setMessageBody:@"I would appreciate if the app implemented the following features:" isHTML:NO];
        [mailVC setModalPresentationStyle:UIModalPresentationFormSheet];
        
        [self presentViewController:mailVC animated:YES completion:NULL];
    } else {
        NSString *recipients = @"mailto:?cc=&subject=";
        NSString *body = @"&body=";
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed!" message:@"Your email was not delivered" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    ThugLifeTutorialPageViewController *tltPageViewController = (ThugLifeTutorialPageViewController *)viewController;
    
    NSInteger index = tltPageViewController.index;
    
    if (index == self.tutorialTitlesArray.count - 1 || index == NSNotFound) {
        return nil;
    } else {
        index++;
    }

    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    ThugLifeTutorialPageViewController *tltPageViewController = (ThugLifeTutorialPageViewController *)viewController;
    
    NSInteger index = tltPageViewController.index;
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    } else {
        index--;
    }
    
    return [self viewControllerAtIndex:index];
}

- (ThugLifeTutorialPageViewController *)viewControllerAtIndex:(NSInteger)index {
    
    if ([self.tutorialTitlesArray count] == 0 || index > [self.tutorialTitlesArray count]) {
        return nil;
    }
    
    ThugLifeTutorialPageViewController *thugLifeTutorialPageViewController = [ThugLifeTutorialPageViewController new];
    thugLifeTutorialPageViewController.index = index;
    thugLifeTutorialPageViewController.thugLifeTitle = self.tutorialTitlesArray[index];
    thugLifeTutorialPageViewController.imageName = self.imageTitlesArray[index];
    
    return thugLifeTutorialPageViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.tutorialTitlesArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)dismissButtonTapped:(id)sender {
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
	ThugLifeTutorialPageViewController *tltPageViewController = (ThugLifeTutorialPageViewController *)pendingViewControllers[0];
	NSInteger index = tltPageViewController.index;
	
	UINavigationItem *navItem = self.pageViewController.navigationItem;
    navItem.title = self.tutorialTitlesArray[index];
}

@end
