//
//  NSString+MCRegExp.m
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/11/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import "NSString+MCRegExp.h"

@implementation NSString (MCRegExp)

- (BOOL)matchesRegEx:(NSString *)string {
    NSPredicate *regExpPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string];
    return [regExpPredicate evaluateWithObject:self];
}
@end
