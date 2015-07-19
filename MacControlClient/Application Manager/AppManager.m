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


#pragma mark - Connecting/Disconnecting to Host
-(void)connectToHost:(NSString *)host port:(NSInteger)port{
    
    if (![host matchesRegEx:IP_REGEX]) {
        [self showAlertWithType:MCALERT_TYPE_INVALID_IP_ENTERED];
        return;
    }
    if (port < 1 || port > 65535) {
        [self showAlertWithType:MCALERT_TYPE_INVALID_PORT_ENTERED];
        return;
    }
    [self.clientSocket connectToHost:host onPort:port withTimeout:TIMEOUT error:nil];
}

-(void)disconnect{
    [self.clientSocket disconnect];
}


#pragma mark - Send Protocol Messages
-(void)sendMoveUpMessage{
    for (int i = 0; i < SENSITIVITY; i++) {
        [self.clientSocket writeData:[MOVE_UP_MESSAGE dataUsingEncoding:NSUTF8StringEncoding]
                         withTimeout:TIMEOUT tag:0];
    }
}

-(void)sendMoveDownMessage{
    for (int i = 0; i < SENSITIVITY; i++) {
        [self.clientSocket writeData:[MOVE_DOWN_MESSAGE dataUsingEncoding:NSUTF8StringEncoding]
                         withTimeout:TIMEOUT tag:0];
    }
}

-(void)sendMoveLeftMessage{
    for (int i = 0; i < SENSITIVITY; i++) {
        [self.clientSocket writeData:[MOVE_LEFT_MESSAGE dataUsingEncoding:NSUTF8StringEncoding]
                         withTimeout:TIMEOUT tag:0];
    }
}
-(void)sendMoveRightMessage{
    for (int i = 0; i < SENSITIVITY; i++) {
        [self.clientSocket writeData:[MOVE_RIGHT_MESSAGE dataUsingEncoding:NSUTF8StringEncoding]
                         withTimeout:TIMEOUT tag:0];
    }
}

-(void)sendLeftDownMessage{
    [self.clientSocket writeData:[HOLD_LEFT_MESSAGE dataUsingEncoding:NSUTF8StringEncoding]
                     withTimeout:TIMEOUT tag:0];
}

-(void)sendLeftUPMessage{
    [self.clientSocket writeData:[RELEASE_LEFT_MESSAGE dataUsingEncoding:NSUTF8StringEncoding]
                     withTimeout:TIMEOUT tag:0];
}

-(void)sendRightDownMessage{
    [self.clientSocket writeData:[HOLD_RIGHT_MESSAGE dataUsingEncoding:NSUTF8StringEncoding]
                     withTimeout:TIMEOUT tag:0];
}

-(void)sendRightUPMessage{
    [self.clientSocket writeData:[RELEASE_RIGHT_MESSAGE dataUsingEncoding:NSUTF8StringEncoding]
                     withTimeout:TIMEOUT tag:0];
}

-(void)sendKeyTyped:(uint16_t)key{
    
    NSString *msg = [NSString stringWithFormat:@"%d\x0D\x0A",key];
    [self.clientSocket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]
                     withTimeout:TIMEOUT tag:0];
}

-(void)sendCloseWindowMessage{
    
}

-(void)sendMinimizeWindowMessage{
    
}

-(void)sendFullscreenWindowMessage{
    
}

#pragma mark - Alerts
-(void)showAlertWithType:(MCAlertType)aType{
   
    UIAlertView *alert;
    switch (aType) {
        case MCALERT_TYPE_INVALID_IP_ENTERED:
            alert = [[UIAlertView alloc] initWithTitle:@"HOST Error" message:@"You have entered an invalid host name or IP address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            break;
        case MCALERT_TYPE_INVALID_PORT_ENTERED:
            alert = [[UIAlertView alloc] initWithTitle:@"PORT Error" message:@"You have entered an invalid port number. It has to match the port set on server. Valid port number is a number between 1 and 65 535." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            break;
        case MCALERT_TYPE_CANNOT_CONNECT_TO_HOST:
            alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Host is unreachable or desktop app is not running or selected port is busy. Try with other port." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            break;
            
        default:
            break;
    }
    [alert show];
}


#pragma mark - <GCDAsyncSocketDelegate> Methods
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    NSString *portNumber = [NSString stringWithFormat:@"%d",port];
    NSDictionary *notifInfo = @{
        @"Host":host,
        @"Port":portNumber
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Connected" object:self userInfo:notifInfo];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Disconnected" object:self];
}
@end
