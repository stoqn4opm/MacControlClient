//
//  MCSettingsViewController.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/15/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCSettingsViewController.h"

@interface MCSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
