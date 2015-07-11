//
//  AppManager.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/11/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "AppManager.h"
#import "NSString+MCRegExp.h"

@implementation AppManager

+ (AppManager *)sharedManager {
    static AppManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc] init];
    });
    
    return sharedInstance;
}

-(void)setIP:(NSString *)IP{
    if (IP != nil && [IP matchesRegEx:@"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"]) {
        
        self.IP = IP;
        return;
    }
    NSLog(@"Trying to set invalid IP Address! Setting 127.0.0.1 instead");
    self.IP = @"127.0.0.1";
}
@end
