//
//  MCMouseRightClick.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/18/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCMouseRightClick.h"
#import "AppManager.h"

@implementation MCMouseRightClick

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RTransperent" object:self];
    [[AppManager sharedManager]sendRightDownMessage];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RFAlpha" object:self];
    [[AppManager sharedManager]sendRightUPMessage];
}
@end
