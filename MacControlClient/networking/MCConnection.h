//
//  MCConnectionManager.h
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/11/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    MCCoordinateX = 0,
    MCCoordinateY
} MCCoordinate;

enum{
    MCOneUnitUP = 1,
    MCOneUnitDown = -1,
};

typedef NSInteger MCUnit;

@interface MCConnection : NSObject <NSStreamDelegate>
@property (nonatomic, strong, readonly) NSInputStream  *inputStream;
@property (nonatomic, strong, readonly) NSOutputStream *outputStream;

- (instancetype)initNetworkCommunicationWithIP:(NSString *)host port:(NSInteger)port;
-(void) moveCoordinate:(MCCoordinate)coordinate units:(MCUnit)unitsToMoveTo;
@end
