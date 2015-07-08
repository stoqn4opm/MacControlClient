//
//  MCMainViewController.m
//  MacControlClient
//
//  Created by Stoqn Stoqnov on 7/8/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMainViewController.h"
#import "SWRevealViewController.h"

@interface MCMainViewController ()

@end

@implementation MCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

@end
