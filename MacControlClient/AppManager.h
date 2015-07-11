//
//  AppManager.h
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/11/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCConnection.h"

@interface AppManager : NSObject

+ (AppManager *)sharedManager;

@property (nonatomic, strong) NSString *IP;
@property  int16_t port;
@property (nonatomic, strong) MCConnection *connection;
@end
