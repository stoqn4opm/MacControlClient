//
//  MCMouseLeftClick.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/18/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMouseLeftClick.h"
#import "AppManager.h"

@implementation MCMouseLeftClick

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LTransperent" object:self];
    [[AppManager sharedManager]sendLeftDownMessage];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LFAlpha" object:self];
    [[AppManager sharedManager]sendLeftUPMessage];
}
@end
