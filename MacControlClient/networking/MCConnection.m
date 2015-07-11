//
//  MCConnectionManager.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/11/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "MCConnection.h"

@implementation MCConnection


-(instancetype)init{
    self = [super init];
    if (self) {
      self = [self initNetworkCommunicationWithIP:@"localhost" port:80];
    }
    return self;
}

- (instancetype)initNetworkCommunicationWithIP:(NSString *)host port:(NSInteger)port{
    self = [super init];
    if (self) {
        
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
        _inputStream  = (__bridge NSInputStream *)readStream;
        _outputStream = (__bridge NSOutputStream *)writeStream;
        
        [_inputStream  setDelegate:self];
        [_outputStream setDelegate:self];
        [_inputStream  scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_inputStream  open];
        [_outputStream open];
    }
    return self;
}

- (void)sendJoinRequestMessage {
    
    NSString *joinMessage  = [NSString stringWithFormat:@"joinRequest"];
    NSData   *data = [[NSData alloc] initWithData:[joinMessage dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

-(void) moveCoordinate:(MCCoordinate)coordinate units:(MCUnit)unitsToMoveTo{
    NSString *selectedCoord;
    if (coordinate == MCCoordinateX) {
        selectedCoord = @"x";
    }
    else if (coordinate == MCCoordinateY){
        selectedCoord = @"y";
    }
    NSString *messageToSend = [NSString stringWithFormat:@"%@:%d",selectedCoord,unitsToMoveTo];
    NSData   *data          = [[NSData alloc] initWithData:[messageToSend dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
    
    NSLog(@"Change coord message\nCoord:%@ units:%d",selectedCoord,unitsToMoveTo);
}




/*  THIS IS HOW TO GET THE SERVER RESPONCE IF I NEED IT
 
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
 
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == self.inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            NSLog(@"Unknown event");
    }
}*/
@end
