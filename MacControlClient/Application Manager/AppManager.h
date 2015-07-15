//
//  AppManager.h
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/11/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

// Config
#define TIMEOUT 5
#define PORT    2222
#define IP_REGEX @"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
#define SENSITIVITY 10
// Communication Protocol
#define MESSAGE_SEPERATOR [GCDAsyncSocket CRLFData]

#define MOVE_UP_MESSAGE         @"coord:y=1\x0D\x0A"
#define MOVE_DOWN_MESSAGE       @"coord:y=-1\x0D\x0A"
#define MOVE_LEFT_MESSAGE       @"coord:x=-1\x0D\x0A"
#define MOVE_RIGHT_MESSAGE      @"coord:x=1\x0D\x0A"
#define HOLD_LEFT_MESSAGE       @"click:left=1\x0D\x0A"
#define RELEASE_LEFT_MESSAGE    @"click:left=0\x0D\x0A"
#define HOLD_RIGHT_MESSAGE      @"click:right=1\x0D\x0A"
#define RELEASE_RIGHT_MESSAGE   @"click:right=0\x0D\x0A"


@interface AppManager : NSObject <GCDAsyncSocketDelegate>

+ (AppManager *)sharedManager;

@property (nonatomic, strong) NSString *IP;
@property  int16_t port;

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

-(void)sendMoveUpMessages:(NSUInteger)count;
-(void)sendMoveDownMessages:(NSUInteger)count;
-(void)sendMoveLeftMessages:(NSUInteger)count;
-(void)sendMoveRightMessages:(NSUInteger)count;

-(void)sendCloseWindowMessage;
-(void)sendMinimizeWindowMessage;
-(void)sendFullscreenWindowMessage;
@end