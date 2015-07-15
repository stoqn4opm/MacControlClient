//
//  MCIconTapHandler.h
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/14/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCIconTapHandlerDelegate <NSObject>

-(void)presentSettings;

@end

@interface MCIconTapHandler : NSObject

@property (weak, nonatomic) id<MCIconTapHandlerDelegate> delegate;

-(void)closeWindowTapped;
-(void)minimizeWindowTapped;
-(void)fullscreenWindowTapped;
-(void)keyboardTapped;
-(void)settingsTapped;

@end
