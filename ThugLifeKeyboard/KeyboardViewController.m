//
//  KeyboardViewController.m
//  ThugLifeKeyboard
//
//  Created by fredhedz on 6/30/15.
//  Copyright (c) 2015 FredHedz. All rights reserved.
//

#import "KeyboardViewController.h"
#import "ThugLifeLyricTableViewCell.h"

@interface KeyboardViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *nextKeyboardButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryPickerButton;
@property (strong, nonatomic) IBOutlet UITableView *lyricsTableView;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;

@property (strong, nonatomic) UITableView *categoryTableview;
@property (strong, nonatomic) NSString *currentCategory;
@property (strong, nonatomic) NSArray *dataArray;

@property (nonatomic) BOOL isToolbarExpanded;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (IBAction)nextKeyboard:(id)sender {
    
    [self advanceToNextInputMode];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isToolbarExpanded = NO;
    
    UINib *nib = [UINib nibWithNibName:@"ThugLifeKeyboardView" bundle:nil];
    NSArray *arr = [nib instantiateWithOwner:self options:nil];
    self.view = arr[0];
    
    [self.lyricsTableView registerClass:[ThugLifeLyricTableViewCell class] forCellReuseIdentifier:@"ThugLifeCell"];
    [self.lyricsTableView setRestorationIdentifier:@"ThugLifeLyricsTable"];
    [self.lyricsTableView setDelegate:self];
    [self.lyricsTableView setDataSource:self];
    [self.lyricsTableView setEstimatedRowHeight:44];
    [self.lyricsTableView setRowHeight:UITableViewAutomaticDimension];
    
    UITableView *categoryTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [categoryTableView setDelegate:self];
    [categoryTableView setDataSource:self];
    [categoryTableView setRestorationIdentifier:@"ThugLifeCategoriesTable"];
    [categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [categoryTableView setEstimatedRowHeight:44];
    [categoryTableView setRowHeight:UITableViewAutomaticDimension];
    [categoryTableView setBackgroundColor:self.toolbarView.backgroundColor];
    
    self.categoryTableview = categoryTableView;
    
}

- (IBAction)categoryPickerButtonTapped:(id)sender {
    //If toolbar is expanded then update lyrics according to category and remove tableview for categories
    //If toolbar is not expanded then add tableview to subview
    
    if (!_isToolbarExpanded) {
        
        //expand to cover the view
        [UIView animateWithDuration:.25 animations:^{
            [self.toolbarView setFrame:self.view.frame];
        }];
        
        //configure tableview for all categories
        
        CGRect tableRect = self.view.frame;
        tableRect.origin.y += _categoryPickerButton.frame.size.height;
        tableRect.size.height = self.view.frame.size.height - _categoryPickerButton.frame.size.height;
        [_categoryTableview setFrame:tableRect];
        [self.toolbarView addSubview:_categoryTableview];
        _isToolbarExpanded = YES;
        
    } else {
        //return to toolbarsize
        [UIView animateWithDuration:.25 animations:^{
            CGSize toolbarSize = CGSizeMake(self.view.frame.size.width, 44);
            [self.toolbarView setFrame:CGRectMake(0, self.view.frame.size.height - 44, toolbarSize.width, toolbarSize.height)];
            [_categoryTableview removeFromSuperview];
        }];
        
        _isToolbarExpanded = NO;
        if (self.currentCategory) {
            [self.lyricsTableView reloadData];
        }
        
    }
}

#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView.restorationIdentifier isEqualToString:_categoryTableview.restorationIdentifier]) {
        return [[[LyricsManager sharedManager] allCategories] count];
    }
    
    if ([tableView.restorationIdentifier isEqualToString:self.lyricsTableView.restorationIdentifier]) {
        
        return [[[LyricsManager sharedManager] fetchForCategory:_currentCategory] count];
    }
    
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    //table for displaying categories
    if ([tableView.restorationIdentifier isEqualToString:_categoryTableview.restorationIdentifier]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.text = [[[LyricsManager sharedManager] allCategories] objectAtIndex:indexPath.row];
        return cell;
    }
    
    //table for displaying lyrics
    if ([tableView.restorationIdentifier isEqualToString:self.lyricsTableView.restorationIdentifier]) {
        
        ThugLifeLyricTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThugLifeCell"];
        
        NSArray *lyricsArray = [[LyricsManager sharedManager] fetchForCategory:_currentCategory];
        ThugLifeLyrics *song = [lyricsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = song.lyric;
        
        //cell.imageView.image = song.thumbnail;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)tableView:(UITableView *)tableView
editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
