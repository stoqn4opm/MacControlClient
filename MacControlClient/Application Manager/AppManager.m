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
//    [self.clientSocket connectToHost:host onPort:port error:nil];
    [self.clientSocket connectToHost:host onPort:port withTimeout:3 error:nil];
    for (int i = 0; i < 30; i++) {
        [[AppManager sharedManager] sendMoveRightMessages:SENSITIVITY];
    }
    for (int i = 0; i < 30; i++) {
        [[AppManager sharedManager] sendMoveUpMessages:SENSITIVITY];
    }
    for (int i = 0; i < 30; i++) {
        [[AppManager sharedManager] sendMoveLeftMessages:SENSITIVITY];
    }
    for (int i = 0; i < 30; i++) {
        [[AppManager sharedManager] sendMoveDownMessages:SENSITIVITY];
    }
}

-(void)disconnect{
    [self.clientSocket disconnect];
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
