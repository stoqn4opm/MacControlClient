//
//  MCMainViewController.m
//  MacControlClient
//
//  Created by Stoqn Stoqnov on 7/8/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMainViewController.h"
#import "SWRevealViewController.h"

@interface MCMainViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *keyboardButton;

@end

@implementation MCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _prepareUI];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)_prepareUI{
    [self.keyboardButton.layer setCornerRadius:5];
    [self.keyboardButton setClipsToBounds:YES];
}
@end
