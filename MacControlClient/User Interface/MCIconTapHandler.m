//
//  MCIconTapHandler.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/14/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCIconTapHandler.h"
#import "AppManager.h"

@implementation MCIconTapHandler

-(void)closeWindowTapped{
    [[AppManager sharedManager] sendCloseWindowMessage];
}
-(void)minimizeWindowTapped{
    [[AppManager sharedManager]sendMinimizeWindowMessage];
}
-(void)fullscreenWindowTapped{
    [[AppManager sharedManager] sendFullscreenWindowMessage];
}
-(void)keyboardTapped{
    // Euther present my custom keyboard or invoke system one
    // and make that keyboard send key press messages
}
-(void)settingsTapped{
    [self.delegate presentSettings];
}
@end
