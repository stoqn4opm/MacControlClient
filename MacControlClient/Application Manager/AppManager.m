//
//  AppManager.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/11/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "AppManager.h"
#import "NSString+MCRegExp.h"

@interface AppManager ()

@end

@implementation AppManager

+ (AppManager *)sharedManager {
    static AppManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark - Setters/Getters
-(void)setIP:(NSString *)IP{
    if ([IP matchesRegEx:IP_REGEX]) {
        _IP = IP;
        [self.clientSocket disconnect];
        [self.clientSocket connectToHost:_IP onPort:self.port error:nil];
        return;
    }
}

-(GCDAsyncSocket *)clientSocket{
    if (_clientSocket) {
        return _clientSocket;
    }
    dispatch_queue_t delegateQ = dispatch_queue_create("com.cydia.mac_control.client.delegate_queue", NULL);
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:delegateQ];
    return _clientSocket;
}


#pragma mark - Send Protocol Messages
-(void)sendMoveUpMessages:(NSUInteger)count{
    for (int i = 0; i < count; i++) {
        [self.clientSocket writeData:[MOVE_UP_MESSAGE dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT tag:0];
    }
}

-(void)sendMoveDownMessages:(NSUInteger)count{
    for (int i = 0; i < count; i++) {
        [self.clientSocket writeData:[MOVE_DOWN_MESSAGE dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT tag:0];
    }
}

-(void)sendMoveLeftMessages:(NSUInteger)count{
    for (int i = 0; i < count; i++) {
        [self.clientSocket writeData:[MOVE_LEFT_MESSAGE dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT tag:0];
    }
}
-(void)sendMoveRightMessages:(NSUInteger)count{
    for (int i = 0; i < count; i++) {
        [self.clientSocket writeData:[MOVE_RIGHT_MESSAGE dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT tag:0];
    }
}
@end
