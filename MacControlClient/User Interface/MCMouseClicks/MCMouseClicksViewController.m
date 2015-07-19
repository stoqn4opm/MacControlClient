//
//  MCMouseClicksViewController.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/18/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMouseClicksViewController.h"
#import "AppManager.h"
#import "MCMouseRightClick.h"
#import "MCMouseLeftClick.h"

@interface MCMouseClicksViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet MCMouseLeftClick *leftField;
@property (weak, nonatomic) IBOutlet MCMouseRightClick *rightField;

@end

@implementation MCMouseClicksViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(setRightTransperent)
                                                name:@"RTransperent" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(setRightFullAlpha)
                                                name:@"RFAlpha" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(setLeftTransperent)
                                                name:@"LTransperent" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(setLeftFullAlpha)
                                                name:@"LFAlpha" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setRightTransperent{
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.rightLabel setAlpha:0];
    }];
}

-(void)setRightFullAlpha{
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.rightLabel setAlpha:1];
    }];
}

-(void)setLeftTransperent{
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.leftLabel setAlpha:0];
    }];
}

-(void)setLeftFullAlpha{
    [UIView animateWithDuration:HIGHLIGHT_TIME animations:^{
        [self.leftLabel setAlpha:1];
    }];
}
@end
