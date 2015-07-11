//
//  NSString+MCRegExp.h
//  MacControlClient
//
//  Created by Stoyan Stoyanov on 7/11/15.
//  Copyright (c) 2015 Stoyan Stoyanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MCRegExp)
- (BOOL)matchesRegEx:(NSString *)string;
@end
